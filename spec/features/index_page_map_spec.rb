require 'spec_helper'

feature 'Index page map', js: true do
  pending 'renders a leaflet map' do
    visit search_catalog_path(q: 'medicine', view: 'maps')
    expect(page).to have_css '.leaflet-map-pane'
    # Zoomed to world
    expect(page).to have_css 'img[src="http://a.basemaps.cartocdn.com/light_all/1/0/0.png"]'
    expect(page).to have_css '#index-map-sidebar', visible: false
    click('svg g path')
    expect(page).to have_css '#index-map-sidebar', visible: true
  end
end
