class PostingsController < ApplicationController
  # GET /postings
  # GET /postings.json
  def index
    origin = geocode(params["address"])
    distance = params["distance"] || 0.5
    @postings = Posting.within(distance, origin: origin).
      joins(:location).
      paginate(:page => params[:page])

    @bounding_box = RGeo::Cartesian::BoundingBox.new RGeo::Geographic.spherical_factory
    @postings.each { |p| @bounding_box.add p.location.point }

    respond_to do |format|
      format.html
      format.geojson { render json: feature_collection }
    end
  end

  private

  def geocode(address)
    location = DcAddressLookup.lookup address
    [location.latitude, location.longitude]
  end

  def feature_collection
    features = @postings.map { |p| p.as_geojson }
    feature_collection = RGeo::GeoJSON::FeatureCollection.new features
    RGeo::GeoJSON.encode feature_collection
  end
end
