# BlacklightHeatmaps
[![Build Status](https://travis-ci.org/sul-dlss/blacklight_heatmaps.svg?branch=master)](https://travis-ci.org/sul-dlss/blacklight_heatmaps) | [![Coverage Status](https://coveralls.io/repos/github/sul-dlss/blacklight_heatmaps/badge.svg?branch=master)](https://coveralls.io/github/sul-dlss/blacklight_heatmaps?branch=master)

![blacklight_heatmap](https://cloud.githubusercontent.com/assets/1656824/16598401/d0538fce-42cb-11e6-86f8-81fd37ab2abe.gif)

## Features
 - Configurable heatmaps of result sets
    - Works with center points and bounding box data
 - Show page map view
 - Changeout the basemap to any tile layer
 - _Really_ fast with large data sets
    - Utilizes Solr's [facet heatmap](https://issues.apache.org/jira/browse/SOLR-7005) feature to provide snappy results. Tested with an index > 10,000,000 records.
 - Customizable result view template

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blacklight_heatmaps'
```

And then execute:

```sh
bundle install
```

Run the BlacklightMaps installer:

```sh
rails generate blacklight_heatmaps:install
```

## Getting started

### Indexing data
BlacklightHeatmaps expects your data to be indexed as a [Spatial Recursive Prefix Tree](https://cwiki.apache.org/confluence/display/solr/Spatial+Search#SpatialSearch-RPT) type. The plugin currently supports data indexed in formats:

 - `x y` Syntax. example: "-121.631609 36.688128"
 - CQL ENVELOPE Syntax (`minX, maxX, maxY, minY`). example: "ENVELOPE(122.934585571, 153.987060547, 45.522888184, 20.422889709)"

BlacklightHeatmaps also works with multivalued Spatial Recursive Prefix Tree types.

```json
{
  "id": 1,
  "name": "Null Island",
  "geo_srpt": [
    "ENVELOPE(-0.0005, 0.000379, 0.000309, -0.000282)", "0 0"
  ]
}
```

Though Solr seems to not be able to handle multivalued points without an accompanying geometry.

Additional formats could be added by extending `BlacklightHeatmaps::GeometryParser`

### Customizing the basemap

By default three different basemaps are included with BlacklightHeatmaps. You can modify these by changing the configuration value in the `CatalogController`.

```ruby
  # Basemaps configured include: 'positron', 'darkMatter', 'OpenStreetMap.HOT'
  config.basemap_provider = 'OpenStreetMap.HOT'
```

BlacklightHeatmaps allows you to customize your basemap further to any Leaflet TileLayer subclass. This includes WMS layers, TileLayers, etc. Checkout [Leaflet Providers](https://github.com/leaflet-extras/leaflet-providers) for more ideas on basemaps you can use.

To customize the basemap, make sure that you extend the `BlacklightHeatmaps.Basemaps` object to include your basemap selection:

```javascript
  BlacklightHeatmaps.Basemaps[' OpenStreetMap.BlackAndWhite'] = L.tileLayer('http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png', {
	maxZoom: 18,
	attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
});
```

### Customizing the color display
The heatmap color ramp is also customizable. This setting can be modified in `CatalogController` by passing in an array of hexadecimal color values as strings.

```ruby
  #Heatmap color ramp. For best results, use http://colorbrewer2.org or http://tristen.ca/hcl-picker/#/hlc/5/1
  config.view.heatmaps.color_ramp = ['#fef0d9','#fdcc8a','#fc8d59','#e34a33','#b30000']
```

![changed_ramp](https://cloud.githubusercontent.com/assets/1656824/16814655/ce3a0170-4904-11e6-8d0f-a9cfb1d44057.png)

[ColorBrewer](http://colorbrewer2.org/) is a great resource in choosing a color ramp. It also has options for colorblind safe ramps to use and can export the hex values in an array that you can paste into your configuration.

## Development

Run Solr and Blacklight (with BlacklightMaps) for interactive development:

```sh
bundle exec rake blacklight_heatmaps:server
```

Run the test suite

```sh
bundle exec rake ci
```
