const IndexView = L.Class.extend({
  options: {},

  initialize: function (el, options) {
    var requestUrl = el.dataset.searchUrl + '&format=heatmaps';
    var geometryField = el.dataset.geometryField;
    var template = el.dataset.sidebarTemplate;
    var colorRamp = JSON.parse(el.dataset.colorRamp);

    // Blank out page link content first and disable pagination
    document.querySelectorAll('#sortAndPerPage .page-links').forEach(function (links) {
      links.innerHTML = '';
    });
    document.querySelectorAll('ul.pagination').forEach(function (links) {
      links.classList.add('d-none');
    });

    var map = L.map(el.id).setView([0, 0], 1);
    var basemap = BlacklightHeatmaps.selectBasemap(
      el.dataset.basemapProvider
    ).addTo(map);

    var solrLayer = L.solrHeatmap(requestUrl, {
      field: geometryField,
      maxSampleSize: 50,
      colors: colorRamp,
    }).addTo(map);

    var sidebar = L.control.sidebar('index-map-sidebar', {
      position: 'right',
    });

    map.addControl(sidebar);

    solrLayer.on('click', function (e) {
      if (!sidebar.isVisible()) {
        map.setView(e.latlng);
      } else {
        var point = map.project(e.latlng);
        var offset = sidebar.getOffset();
        var newPoint = L.point(point.x - (offset / 2), point.y);
        map.setView(map.unproject(newPoint));
      }

      sidebar.show();
    });

    solrLayer.on('dataAdded', function (e) {
      if (e.response && e.response.docs) {
        var html = '';
        e.response.docs.forEach(function (value) {
          html += L.Util.template(template, value);
        });

        sidebar.setContent(html);

        var docCount = e.response.pages.total_count;

        document.querySelectorAll('#sortAndPerPage .page-links').forEach(function (links) {
          links.innerHTML = parseInt(docCount).toLocaleString() + ' ' + (docCount == 1 ? 'item' : 'items') + ' found';
        });
      }
    });
  },

  pluralize: function (count, word) {
    switch (count) {
      case 1:
        return word;
      default:
        return word + 's';
    }
  },
});

export default IndexView;
