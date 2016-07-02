require 'spec_helper'

feature 'Index page map', js: true do
  it 'renders a leaflet map' do
    visit search_catalog_path(q: 'strong', view: 'heatmaps')
    expect(page).to have_css '.leaflet-map-pane'
    # Zoomed to world
    expect(page).to have_css 'img[src="http://a.basemaps.cartocdn.com/light_all/1/0/0.png"]'
    expect(page).to have_css '#index-map-sidebar', visible: false
    page.find('svg g path').click
    expect(page).to have_css '#index-map-sidebar', visible: true
    expect(page)
      .to have_css 'h3.media-heading a', text: '"Strong Medicine speaks"'
  end
end
