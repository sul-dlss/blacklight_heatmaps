require 'spec_helper'

feature 'Configurable basemap', js: true do
  scenario 'defaults to positron' do
    visit search_catalog_path(q: ' ', view: 'heatmaps', search_field: 'all_fields')
    expect(page).to have_css "img[src*='light_all']"
  end
  feature 'without configured basemap' do
    before do
      CatalogController.blacklight_config.basemap_provider = nil
    end
    scenario 'defaults to positron' do
      visit search_catalog_path(q: ' ', view: 'heatmaps', search_field: 'all_fields')
      expect(page).to have_css "img[src*='light_all']"
    end
  end
  feature 'with alterate configured basemap' do
    before do
      CatalogController.blacklight_config.basemap_provider = 'darkMatter'
    end
    after do
      CatalogController.blacklight_config.basemap_provider = 'positron'
    end
    scenario 'defaults to positron' do
      visit search_catalog_path(q: ' ', view: 'heatmaps', search_field: 'all_fields')
      expect(page).to have_css "img[src*='dark_all']"
    end
  end
end

