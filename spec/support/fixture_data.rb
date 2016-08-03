module FixtureData
  def null_island
    File.read(Pathname.new(File.expand_path('../../fixtures/null_island.geojson', __FILE__)))
  end
end

RSpec.configure do |config|
  config.include FixtureData, :include_fixtures
end
