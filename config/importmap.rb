
# frozen_string_literal: true

# Leaflet viewer
pin "leaflet", to: "https://cdn.skypack.dev/leaflet@1.9.4"

pin_all_from BlacklightHeatmaps::Engine.root.join("app", "javascript", "blacklight_heatmaps"), under: "blacklight_heatmaps"
pin "blacklight_heatmaps/application"

# vendor/javascript pins (excluding geostats, which we append to the _head partial)
pin "solr_heatmap", to: "leaflet_solr_heatmap.js"
pin "control_sidebar", to: "leaflet_control_sidebar.js"
