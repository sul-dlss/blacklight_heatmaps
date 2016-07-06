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

BlacklightHeatmaps expects your data to be indexed as a [Spatial Recursive Prefix Tree](https://cwiki.apache.org/confluence/display/solr/Spatial+Search#SpatialSearch-RPT) type. The plugin currently supports data indexed in formats:

 - `x y` Syntax. example: "-121.631609 36.688128"
 - CQL ENVELOPE Syntax (`minX, maxX, maxY, minY`). example: "ENVELOPE(122.934585571, 153.987060547, 45.522888184, 20.422889709)"

Additional formats could be added by extending `BlacklightHeatmaps::GeometryParser`

## Development

Run Solr and Blacklight (with BlacklightMaps) for interactive development:

```sh
bundle exec rake blacklight_heatmaps:server
```

Run the test suite

```sh
bundle exec rake ci
```
