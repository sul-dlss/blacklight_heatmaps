Blacklight.onLoad(function () {
  'use strict';

  $('[data-show-map]').each(function () {
    BlacklightHeatmaps.showView(this);
  });
});

!(function (global) {
  'use strict';

  var ShowView = L.Class.extend({
    options: {},

    initialize: function (el, options) {
      var $el = $(el);
      var features = $el.data().features;

      var map = L.map($el[0].id).setView([0, 0], 1);
      var basemap = L.tileLayer($el.data().basemap, {
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
      }).addTo(map);

      var features = L.geoJson(features).addTo(map);

      map.fitBounds(features.getBounds());
    },
  });

  global.BlacklightHeatmaps.ShowView = ShowView;
  global.BlacklightHeatmaps.showView = function (el, options) {
    return new ShowView(el, options);
  };
})(this);
