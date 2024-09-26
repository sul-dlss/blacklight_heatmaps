Blacklight.onLoad(function () {
  'use strict';

  document.querySelectorAll('[data-show-map]').forEach(function (el) {
    BlacklightHeatmaps.showView(el);
  });
});

!(function (global) {
  'use strict';

  var ShowView = L.Class.extend({
    options: {},

    initialize: function (el, options) {
      var json = JSON.parse(el.dataset.features);

      var map = L.map(el.id).setView([0, 0], 1);
      var basemap = BlacklightHeatmaps.selectBasemap(
        el.dataset.basemapProvider
      ).addTo(map);

      var features = L.geoJson(json, {
        pointToLayer: function(feature, latlng) {
          return L.marker(latlng, {
            icon: BlacklightHeatmaps.Icons.default
          })
        }
      }).addTo(map);

      map.fitBounds(features.getBounds());
    },
  });

  global.BlacklightHeatmaps.ShowView = ShowView;
  global.BlacklightHeatmaps.showView = function (el, options) {
    return new ShowView(el, options);
  };
})(this);
