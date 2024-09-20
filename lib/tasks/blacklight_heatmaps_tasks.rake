# Tasks shared with the consuming application
namespace :blacklight_heatmaps do
  namespace :index do
    desc 'Put sample data into Solr'
    task :seed, [:datafile] => [:environment] do |_t, args|
      args.with_defaults(datafile: 'sample_solr_documents')
      fn = File.join(BlacklightHeatmaps::Engine.root, 'solr', args[:datafile] + '.yml')
      puts "Indexing sample data from #{fn}"
      docs = YAML.load(File.open(fn))
      conn = Blacklight.default_index.connection
      conn.add docs
      conn.commit
    end
  end
end
