class ZoningCasesController < ApplicationController
  before_action :set_zoning_case, only: [:show]

  def index
    if params["address"]
      origin = geocode(params["address"])
      distance = params["distance"] || 0.5
      @zoning_cases = ZoningCase.within(distance, :origin => origin).
        paginate(:page => params[:page])
    else
      @zoning_cases = ZoningCase.paginate(:page => params[:page])
    end
  end

  def show
    respond_to do |format|
      format.html
      format.geojson { render json: @zoning_case.to_geojson }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_zoning_case
    @zoning_case = ZoningCase.find(params[:id])
  end

  def geocode(address)
    address_with_city = "#{address}, Washington, DC"
    location = DcAddressLookup.lookup address_with_city
    [location.latitude, location.longitude]
  end
end
