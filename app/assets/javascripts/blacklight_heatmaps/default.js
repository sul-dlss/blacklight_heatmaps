(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory(require('leaflet'), require('solr_heatmap'), require('control_sidebar')) :
  typeof define === 'function' && define.amd ? define(['leaflet', 'solr_heatmap', 'control_sidebar'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.BlacklightHeatmaps = factory(global.L));
})(this, (function (L$1) { 'use strict';

  const basemaps = {
    darkMatter: L$1.tileLayer(
      'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
        maxZoom: 18,
        worldCopyJump: true,
        detectRetina: true,
      }
    ),
    positron: L$1.tileLayer(
      'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
        maxZoom: 18,
        worldCopyJump: true,
        detectRetina: true,
      }
    ),
    'OpenStreetMap.HOT': L$1.tileLayer(
      'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>',
        maxZoom: 19,
      }
    ),
  };

  const selectBasemap = (basemap) => {
    return basemap && basemaps[basemap]
      ? basemaps[basemap]
      : basemaps.positron;
  };

  class ShowView {
    constructor(el, options) {
      this.options = options;

      const json = JSON.parse(el.dataset.features);

      // Load leaflet icon images from CDN (used below in L.Icon.Default)
      // Follow the approach of geoBlacklight; skypack ESM does not host images
      L$1.Icon.Default.imagePath = "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/";

      const mapInstance = L$1.map(el.id).setView([0, 0], 1);
      selectBasemap(
        el.dataset.basemapProvider
      ).addTo(mapInstance);

      const features = L$1.geoJson(json, {
        pointToLayer: (feature, latlng) => {
          return L$1.marker(latlng, {
            icon: new L.Icon.Default(),
          });
        },
      }).addTo(mapInstance);

      mapInstance.fitBounds(features.getBounds());
    }
  }

  class IndexView {
    constructor(el, options) {
      this.options = options;

      const requestUrl = `${el.dataset.searchUrl}&format=heatmaps`;
      const geometryField = el.dataset.geometryField;
      const template = el.dataset.sidebarTemplate;
      const colorRamp = JSON.parse(el.dataset.colorRamp);

      // Blank out page link content first and disable pagination
      document.querySelectorAll('#sortAndPerPage .page-links').forEach((links) => {
        links.innerHTML = '';
      });
      document.querySelectorAll('ul.pagination').forEach((links) => {
        links.classList.add('d-none');
      });

      const mapInstance = L$1.map(el.id).setView([0, 0], 1);
      selectBasemap(
        el.dataset.basemapProvider
      ).addTo(mapInstance);

      const solrLayer = L.solrHeatmap(requestUrl, {
        field: geometryField,
        maxSampleSize: 50,
        colors: colorRamp,
      }).addTo(mapInstance);

      const sidebar = L.control.sidebar('index-map-sidebar', {
        position: 'right',
      });

      mapInstance.addControl(sidebar);

      solrLayer.on('click', (e) => {
        if (!sidebar.isVisible()) {
          mapInstance.setView(e.latlng);
        } else {
          const pointInstance = mapInstance.project(e.latlng);
          const offset = sidebar.getOffset();
          const newPoint = L$1.point(pointInstance.x - (offset / 2), pointInstance.y);
          mapInstance.setView(mapInstance.unproject(newPoint));
        }

        sidebar.show();
      });

      solrLayer.on('dataAdded', (e) => {
        if (e.response && e.response.docs) {
          let html = '';
          e.response.docs.forEach((value) => {
            html += L$1.Util.template(template, this.format_data(value));
          });

          sidebar.setContent(html);

          const docCount = e.response.pages.total_count;

          document.querySelectorAll('#sortAndPerPage .page-links').forEach((links) => {
            links.innerHTML = `${parseInt(docCount).toLocaleString()} ${docCount === 1 ? 'item' : 'items'} found`;
          });
        }
      });
    }

    pluralize(count, word) {
      return count === 1 ? word : `${word}s`;
    }

    format_data(data) {
      return {
        title: data?.title,
        url: `/catalog/${data?.url?.id}`,
      }
    }
  }

  // Initialize on load
  const initializeMaps = () => {

    console.log('initialize maps');
    document.querySelectorAll('[data-show-map]').forEach(el => {
      new ShowView(el);
    });

    document.querySelectorAll('[data-index-map]').forEach(el => {
      new IndexView(el);
    });
  };

  // Inspired by GeoBlacklight and Blacklight's core.js
  const BlacklightHeatmaps = (function () {
      const callbacks = [];
      return {
        // Hook: pass a callback to add it to the activation stack
        onLoad: function (callback) {
          callbacks.push(callback);
        },
    
        // Activate all stored callbacks
        activate: function (event) {
          callbacks.forEach((callback) => {
            callback(event);
          });
        },
    
        // Define hooks that will trigger the activation of the BlacklightHeatmaps JS
        listeners: function () {
          if (typeof Turbo !== "undefined")
            return ["turbo:load", "turbo:frame-load"];
          else return ["DOMContentLoaded"];
        },
      };
    })();

    // Add event listeners that call activate() for each event type
    BlacklightHeatmaps.listeners().forEach((listener) =>
      document.addEventListener(listener, (event) => BlacklightHeatmaps.activate(event))
    );

    BlacklightHeatmaps.onLoad(initializeMaps);


  // Register our Stimulus controllers
  if (typeof Stimulus !== "undefined") {
    console.info("Registering BlacklightHeatmaps Stimulus controllers");
  } else {
    console.error(
      "Couldn't find Stimulus. Check installation instructions at https://github.com/hotwired/stimulus-rails."
    );
  }

  const index = {
      Core: BlacklightHeatmaps,
      onLoad: BlacklightHeatmaps.onLoad,
    };

  return index;

}));
//# sourceMappingURL=default.js.map
