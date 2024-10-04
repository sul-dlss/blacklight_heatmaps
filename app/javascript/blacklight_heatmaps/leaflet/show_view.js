'use strict';

import { selectBasemap } from 'blacklight_heatmaps/leaflet/basemap_util';
import { map, geoJson, marker } from 'leaflet';

class ShowView {
  constructor(el, options) {
    this.options = options;

    const json = JSON.parse(el.dataset.features);

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