import ShowView from 'blacklight_heatmaps/leaflet/show_view'
import IndexView from 'blacklight_heatmaps/leaflet/index_view';

// Initialize on load
const initializeMaps = () => {
  'use strict';

  console.log('initialize maps')
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

export default BlacklightHeatmaps;
