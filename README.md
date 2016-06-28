# BlacklightMaps
[![Build Status](https://travis-ci.org/sul-dlss/blacklight_maps.svg?branch=master)](https://travis-ci.org/sul-dlss/blacklight_maps)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blacklight_maps'
```

And then execute:

```sh
bundle install
```

Run the BlacklightMaps installer:

```sh
rails generate blacklight_maps:install
```

## Development

Run Solr and Blacklight (with BlacklightMaps) for interactive development:

```sh
bundle exec rake blacklight_maps:server
```

Run the test suite

```sh
bundle exec rake ci
```
