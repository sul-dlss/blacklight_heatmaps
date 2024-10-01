'use strict';

import { selectBasemap } from 'blacklight_heatmaps/leaflet/basemap_util';
import { map, geoJson, marker, Icon } from 'leaflet';

class ShowView {
  constructor(el, options) {
    this.options = options;

    const json = JSON.parse(el.dataset.features);

    // Load leaflet icon images from CDN (used below in L.Icon.Default)
    // Follow the approach of geoBlacklight; skypack ESM does not host images
    Icon.Default.imagePath = "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/";

    const mapInstance = map(el.id).setView([0, 0], 1);
    selectBasemap(
      el.dataset.basemapProvider
    ).addTo(mapInstance);

    const features = geoJson(json, {
      pointToLayer: (feature, latlng) => {
        return marker(latlng, {
          icon: new L.Icon.Default(),
        });
      },
    }).addTo(mapInstance);

    mapInstance.fitBounds(features.getBounds());
  }
}

export default ShowView;