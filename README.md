# BlacklightHeatmaps
[![Build Status](https://travis-ci.org/sul-dlss/blacklight_heatmaps.svg?branch=master)](https://travis-ci.org/sul-dlss/blacklight_heatmaps) | [![Coverage Status](https://coveralls.io/repos/github/sul-dlss/blacklight_heatmaps/badge.svg?branch=master)](https://coveralls.io/github/sul-dlss/blacklight_heatmaps?branch=master)

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

## Development

Run Solr and Blacklight (with BlacklightMaps) for interactive development:

```sh
bundle exec rake blacklight_heatmaps:server
```

Run the test suite

```sh
bundle exec rake ci
```
