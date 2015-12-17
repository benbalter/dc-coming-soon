class AbraNoticesController < ApplicationController
  before_action :set_abra_notice, only: [:show]
  caches_action :show

  # GET /abra_notices
  # GET /abra_notices.json
  def index
    if params["address"]
      origin = geocode(params["address"])
      distance = params["distance"] || 0.5
      @abra_notices = AbraNotice.joins(:licensee).
        within(distance, :origin => origin).
        paginate(:page => params[:page]).
        order("abra_notices.posting_date desc")
    else
      @abra_notices = AbraNotice.paginate(:page => params[:page]).
        order("abra_notices.posting_date desc")
    end
  end

  # GET /abra_notices/1
  # GET /abra_notices/1.json
  def show
    respond_to do |format|
      format.html
      format.geojson { render json: @abra_notice.to_geojson }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_abra_notice
      @abra_notice = AbraNotice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def abra_notice_params
      params.require(:abra_notice).permit(:posting_date, :petition_date, :hearing_date, :protest_date, :anc_id, :license_class_id)
    end

    def geocode(address)
      address_with_city = "#{address}, Washington, DC"
      location = DcAddressLookup.lookup address_with_city
      [location.latitude, location.longitude]
    end
end
