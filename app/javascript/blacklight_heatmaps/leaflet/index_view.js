'use strict';

import "solr_heatmap";
import "control_sidebar";
import { selectBasemap } from 'blacklight_heatmaps/leaflet/basemap_util';
import { map, point, Util } from 'leaflet';     

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

    const mapInstance = map(el.id).setView([0, 0], 1);
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
        const newPoint = point(pointInstance.x - (offset / 2), pointInstance.y);
        mapInstance.setView(mapInstance.unproject(newPoint));
      }

      sidebar.show();
    });

    solrLayer.on('dataAdded', (e) => {
      if (e.response && e.response.docs) {
        let html = '';
        e.response.docs.forEach((value) => {
          html += Util.template(template, this.format_data(value));
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

export default IndexView;
