//= require leaflet

Blacklight.onLoad(function () {
  'use strict';

  $('[data-show-map]').each(function () {
    var $el = $(this);
    var features = $el.data().features;

    var map = L.map($el[0].id).setView([0, 0], 1);
    var basemap = L.tileLayer($el.data().basemap, {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
    }).addTo(map);

    var features = L.geoJson(features).addTo(map);

    map.fitBounds(features.getBounds());
  });
});
