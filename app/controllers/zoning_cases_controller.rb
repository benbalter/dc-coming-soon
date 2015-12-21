class ZoningCasesController < ApplicationController
  before_action :set_zoning_case, only: [:show]

  def show
    respond_to do |format|
      format.html
      format.geojson { render json: @zoning_case.to_geojson }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_zoning_case
    @zoning_case = Posting.find(params[:id])
  end
end
