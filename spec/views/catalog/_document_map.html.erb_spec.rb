require 'spec_helper'

describe 'catalog/_document_maps.html.erb' do
  let(:blacklight_config) { Blacklight::Configuration.new }
  it 'renders a div with needed elements' do
    blacklight_config.configure do |config|
      config.geometry_field = :geo_srpt
    end
    render partial: 'catalog/document_maps',
           locals: { blacklight_config: blacklight_config }
    expect(rendered).to have_css '.blacklight-maps-index-map-container'
    expect(rendered).to have_css '#index-map.blacklight-maps-index-map'
    expect(rendered).to have_css '[data-index-map="true"]'
    expect(rendered).to have_css '[data-search-url="http://test.host"]'
    expect(rendered).to have_css '[data-geometry-field="geo_srpt"]'
  end
end
