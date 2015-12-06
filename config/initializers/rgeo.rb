RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  config.default = RGeo::Geographic.spherical_factory(srid: 4326)
end

RGeo::ActiveRecord::GeometryMixin.set_json_generator(:geojson)
