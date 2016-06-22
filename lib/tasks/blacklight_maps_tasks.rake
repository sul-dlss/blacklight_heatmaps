# Tasks shared with the consuming application
namespace :blacklight_maps do
  namespace :index do
    desc 'Put sample data into Solr'
    task seed: [:environment] do
      docs = YAML.load(File.open(File.join(BlacklightMaps::Engine.root, 'solr', 'sample_solr_documents.yml')))
      conn = Blacklight.default_index.connection
      conn.add docs
      conn.commit
    end
  end
end
