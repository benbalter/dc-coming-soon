class AbraNoticesController < ApplicationController
  before_action :set_abra_notice, only: [:show]
  caches_action :show

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
end
