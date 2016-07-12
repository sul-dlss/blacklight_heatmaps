require 'spec_helper'

feature 'Back to search button', js: true do
  pending 'returns to index page and not json response' do
    visit search_catalog_path(q: ' ', view: 'heatmaps', search_field: 'all_fields')
    expect(page).to have_css '.leaflet-map-pane'
    page.first('svg g path').click
    expect(page).to have_css '#index-map-sidebar', visible: true
    page.first('h3.media-heading a').click
    page.first('.search-widgets a').click
    page.save_and_open_screenshot
    expect(page).to have_css '.page_links', text: '17 items found'
  end
end
