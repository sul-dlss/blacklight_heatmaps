!(function (global) {
  'use strict';

  var BlacklightHeatmaps = L.Class.extend({
    statics: {
      __version__: '0.0.3',

      selectBasemap: function (basemap) {
        if (basemap && basemap !== undefined) {
          return BlacklightHeatmaps.Basemaps[basemap];
        } else {
          return BlacklightHeatmaps.Basemaps.positron;
        }
      },
    },
  });
  global.BlacklightHeatmaps = BlacklightHeatmaps;
}(this));
