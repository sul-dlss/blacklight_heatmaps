require 'spec_helper'

describe 'catalog/_document_heatmaps.html.erb' do
  let(:blacklight_config) { Blacklight::Configuration.new }
  before do
    allow(view).to receive(:index_map_div)
      .and_return '<div id="index-map"></div>'.html_safe
  end
  it 'renders a div with needed elements' do
    blacklight_config.configure do |config|
      config.geometry_field = :geo_srpt
    end
    render partial: 'catalog/document_heatmaps',
           locals: { blacklight_config: blacklight_config }
    expect(rendered).to have_css '.blacklight-heatmaps-index-map-container'
    expect(rendered).to have_css '#index-map'
    expect(rendered).to have_css '#index-map-sidebar'
  end
end
