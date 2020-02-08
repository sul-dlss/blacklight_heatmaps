require 'spec_helper'

feature 'Index page map', js: true do
  it 'renders a leaflet map' do
    visit search_catalog_path(q: ' ', view: 'heatmaps', search_field: 'all_fields')
    expect(page).to have_css '.leaflet-map-pane'

    # Zoomed to world
    expect(page).to have_css 'img[src*="/light_all/1/0/0.png"]'

    # Hides pagination
    expect(page).to have_css 'nav.pagination', visible: false
    expect(page).to have_css 'ul.pagination', visible: false

    # Document counts
    expect(page).to have_css '.page-links', text: '18 items found'

    expect(page).to have_css '#index-map-sidebar', visible: false
    page.first('svg g path').click
    expect(page).to have_css '#index-map-sidebar', visible: true
    expect(page)
      .to have_css 'h3.media-heading a', text: '"Strong Medicine speaks"'
  end
end
