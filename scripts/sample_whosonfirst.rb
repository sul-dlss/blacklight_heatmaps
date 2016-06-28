#!/usr/bin/env ruby

# TODO: Needs MAJOR cleanup

require 'open-uri'
require 'json'
require 'yaml'

class SampleWhosonfirst
  # https://whosonfirst.mapzen.com/spelunker/random
  # Redirects to an HTML page with the following GeoJSON link:
  #   <a href="/data/722/781/341/722781341.geojson" target="data">Raw data (GeoJSON)</a>
  def self.random_place
    open('https://whosonfirst.mapzen.com/spelunker/random') do |f|
      html = f.read
      if html =~ /\<a href="(\/data\/\d+\/\d+\/\d+\/\d+\.geojson)" target="data"/
        return JSON.parse(open('https://whosonfirst.mapzen.com' + Regexp.last_match(1)).read)
      end
    end
    nil
  rescue OpenURI::HTTPError
    nil
  end

  def self.to_solr(place)
    doc = {}
    return doc if place.nil?
    props = place['properties']
    # puts place.to_yaml

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

(ARGV.first || 1).to_i.times do |i|
  puts SampleWhosonfirst.to_solr(SampleWhosonfirst.random_place).to_yaml
end

# Some good sample data:
# puts SampleWhosonfirst.to_solr(JSON.parse(open('https://whosonfirst.mapzen.com/data/101/720/229/101720229.geojson').read)).to_yaml
# puts SampleWhosonfirst.to_solr(JSON.parse(open('https://whosonfirst.mapzen.com/data/639/115/859/639115859.geojson').read)).to_yaml
