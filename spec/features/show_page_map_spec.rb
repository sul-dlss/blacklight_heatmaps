require 'spec_helper'

feature 'Show map map', js: true do
  it 'renders a leaflet map' do
    visit solr_document_path '43037890'
    expect(page).to have_css '.leaflet-map-pane'

    # Conditionally check for the tile only on GitHub CI
    # Leaflet chooses tile zoom based on retina; this causes tests to fail locally
    if ENV['GITHUB_ACTIONS']
      # Zoomed to Kazakhstan
      expect(page).to have_css 'img[src*="light_all/4/11/5.png"]'
    end

    expect(page).to have_css 'svg g path'
  end
  it 'renders a point type and a polygon' do
    visit solr_document_path '34860108'
    within '.leaflet-container' do
      expect(page).to have_css 'svg g path'
      expect(page).to have_css '.leaflet-marker-icon'
    end
  end
end
