import L from 'leaflet'
import '../../vendor/assets/javascripts/leaflet_solr_heatmap'
import Basemaps from './basemaps'
import Icons from './icons'
import IndexView from './viewers/index'
import ShowView from './viewers/show'

const BlacklightHeatmaps = L.Class.extend({
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
})

BlacklightHeatmaps.Basemaps = Basemaps
BlacklightHeatmaps.Icons = Icons
BlacklightHeatmaps.IndexView = IndexView
BlacklightHeatmaps.indexView = function (el, options) {
    return new IndexView(el, options)
}
BlacklightHeatmaps.ShowView = ShowView;
BlacklightHeatmaps.showView = function (el, options) {
  return new ShowView(el, options);
};

Blacklight.onLoad(function () {
  document.querySelectorAll('[data-index-map]').forEach(function (el) {
    BlacklightHeatmaps.indexView(el, {});
  })
  document.querySelectorAll('[data-show-map]').forEach(function (el) {
    BlacklightHeatmaps.showView(el);
  });
})

export default BlacklightHeatmaps;
