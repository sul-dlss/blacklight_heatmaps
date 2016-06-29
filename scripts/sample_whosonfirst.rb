#!/usr/bin/env ruby
#
# Usage: ruby scripts/sample_whosonfirst.rb [n]
#
require 'open-uri'
require 'json'
require 'yaml'

class Place
  # https://whosonfirst.mapzen.com/spelunker/random
  # Redirects to an HTML page with the following GeoJSON link:
  #   <a href="/data/722/781/341/722781341.geojson" target="data">Raw data (GeoJSON)</a>
  def self.random
    open('https://whosonfirst.mapzen.com/spelunker/random') do |f|
      html = f.read
      if html =~ /\<a href="(\/data\/\d+\/\d+\/\d+\/\d+\.geojson)" target="data"/
        return self.new(JSON.parse(open('https://whosonfirst.mapzen.com' + Regexp.last_match(1)).read))
      end
    end
    nil
  rescue OpenURI::HTTPError
    nil
  end

  attr_reader :place
  def initialize(place)
    @place = place
  end

  def to_solr
    doc = {}
    return doc if place.nil?
    props = place['properties']
    # puts place.to_yaml

    fail 'Missing ID' if place['id'].to_s.empty? # spelunker sometimes is missing an ID value -- dunno why
    doc['id'] = place['id']

    doc['title_display'] = props['wof:name']

    doc['subject_geo_facet'] = []
    doc['subject_geo_facet'] << props['qs:a0'] unless props['qs:a0'].nil?
    doc['subject_geo_facet'] << props['sg:province'] unless props['sg:province'].nil?
    doc['subject_geo_facet'] << props['wof:country'] unless props['wof:country'].nil?

    doc['subject_topic_facet'] = []
    doc['subject_topic_facet'] << props['wof:placetype'] unless props['wof:placetype'].nil?
    doc['subject_topic_facet'] << props['sg:classifiers'].first['category'] unless props['sg:classifiers'].nil? || props['sg:classifiers'].first.nil?

    doc['geo_srpt'] = case place['geometry']['type']
    when 'Point'
      [props['geom:longitude'], props['geom:latitude']].join(' ')
    when 'Polygon'
      west, south, east, north = props['geom:bbox'].split(',')
      "ENVELOPE(#{west}, #{east}, #{north}, #{south})"
    else
      fail "Unknown Geometry Type: #{place['geometry']['type']}"
    end
    doc
  end
end

class SampleWhosonfirst
  def self.cli(args)
    places = []
    (args.first || 1).to_i.times do |i|
      begin
        place = Place.random
        $stderr.puts "Found place #{i+1}: #{place.place['properties']['wof:name']} at #{place.to_solr['geo_srpt']}" if $verbose
        places << place
      rescue NoMethodError, RuntimeError # sometimes spelunker random feature barfs with nil
        retry
      end
    end
    puts places.map(&:to_solr).to_yaml
  end
end

# __MAIN__
$verbose = true
SampleWhosonfirst.cli(ARGV)

# Some good sample data:
# puts Place.new(JSON.parse(open('https://whosonfirst.mapzen.com/data/101/720/229/101720229.geojson').read)).to_solr.to_yaml
# puts Place.new(JSON.parse(open('https://whosonfirst.mapzen.com/data/639/115/859/639115859.geojson').read)).to_solr.to_yaml
