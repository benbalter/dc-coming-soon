# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

mapboxgl = require 'mapbox-gl'

mapboxgl.accessToken = 'pk.eyJ1IjoiYmVuYmFsdGVyIiwiYSI6InZvY0VLdVUifQ.WW6hxWXmvz1iO5vwtFso5Q';

$(document).on 'ready page:load', ->

  $map = $("#map")

  options = {
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v8',
    zoom: 15
    interactive: false,
  }

  if $map.data("lon") and $map.data("lat")
    options["center"] = [$map.data("lon"), $map.data("lat")]

  map = new mapboxgl.Map(options)
  source = new mapboxgl.GeoJSONSource({
    data: $map.data("geojson-url")
  })

  map.on 'style.load', ->
    map.addSource('marker', source)

    map.addLayer({
      "id": "marker",
      "type": "symbol",
      "source": "marker",
      "layout": {
        "icon-image": "bar-15",
        "text-field": "{trade_name}",
        "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
        "text-offset": [0, 0.6],
        "text-anchor": "top"
      },
      "paint": {
        "text-size": 12
      }
    })

    if $map.data("min-x") and $map.data("min-y")
      sw = new mapboxgl.LngLat($map.data("min-x"), $map.data("min-y"))
      ne = new mapboxgl.LngLat($map.data("max-x"), $map.data("max-y"))
      llb = new mapboxgl.LngLatBounds(sw, ne)
      map.fitBounds(llb, { padding: 25, speed: 10, curve: 1})
