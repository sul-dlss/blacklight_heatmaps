# BlacklightHeatmaps
[![Build Status](https://travis-ci.org/sul-dlss/blacklight_heatmaps.svg?branch=master)](https://travis-ci.org/sul-dlss/blacklight_heatmaps)

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
 - CQL ENVELOPE Syntax. "ENVELOPE(122.934585571, 153.987060547, 45.522888184, 20.422889709)"

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
