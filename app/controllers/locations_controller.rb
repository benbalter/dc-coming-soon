class LocationsController < ApplicationController

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])
    @postings = @location.postings.paginate(:page => params[:page])
  end
end
