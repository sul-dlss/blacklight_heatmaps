require 'spec_helper'

RSpec.feature 'Index page map', js: true do
  it 'renders a leaflet map' do
    visit search_catalog_path(q: ' ', view: 'heatmaps', search_field: 'all_fields')
    expect(page).to have_css '.leaflet-map-pane'

    # Conditionally check for the PNG only on GitHub CI
    # Leaflet chooses tile zoom based on retina; this causes tests to fail locally
    if ENV['GITHUB_ACTIONS']
      # Zoomed to world
      expect(page).to have_css 'img[src*="/light_all/1/0/0.png"]'
    end

    # Hides pagination
    expect(page).to have_css 'ul.pagination', visible: false
    expect(page).not_to have_css '.page-links a'

    # Document counts
    expect(page).to have_css '.page-links', text: '18 items found'

    expect(page).to have_css '#index-map-sidebar', visible: false
    page.first('svg g path').click
    expect(page).to have_css '#index-map-sidebar', visible: true
    expect(page)
      .to have_css 'h3.media-heading a', text: '"Strong Medicine speaks"'
  end

  it 'renders an empty map when no results have geometry' do
    visit search_catalog_path(q: '00282214', view: 'heatmaps', search_field: 'all_fields')
    expect(page).to have_css '.leaflet-map-pane'

    # Document counts are only rendered after the heatmap data is processed
    expect(page).to have_css '.page-links', text: '0 items found'
    expect(page).not_to have_css 'svg g path'
  end
end
