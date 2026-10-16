# Tasks used within the development of BlacklightHeatmaps

require 'net/http'
require 'solr_wrapper'
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Run Solr with docker compose when it's available, otherwise with solr_wrapper.
def with_solr(&block)
  if system('docker compose version', out: File::NULL, err: File::NULL)
    begin
      puts 'Starting Solr'
      system('docker compose up -d solr', exception: true)
      wait_for_solr
      yield
    ensure
      puts 'Stopping Solr'
      system('docker compose stop solr')
    end
  else
    SolrWrapper.wrap(port: '8983') do |solr|
      solr.with_collection(name: 'blacklight-core', dir: File.join(File.expand_path('..', File.dirname(__FILE__)), 'solr', 'conf'), &block)
    end
  end
end

# `docker compose up -d` returns before Solr has created the core.
def wait_for_solr(timeout: 60)
  ping = URI('http://127.0.0.1:8983/solr/blacklight-core/admin/ping')
  deadline = Time.now + timeout

  until (Net::HTTP.get_response(ping).is_a?(Net::HTTPSuccess) rescue false)
    raise "Solr did not respond at #{ping} within #{timeout} seconds" if Time.now > deadline

    sleep 1
  end
end

desc 'Run test suite'
task ci: ['blacklight_heatmaps:generate'] do
  with_solr do
    within_test_app do
      system 'bin/rake spec:prepare'
      system 'RAILS_ENV=test rake blacklight_heatmaps:index:seed'
    end
    Rake::Task['spec'].invoke
  end
end

namespace :blacklight_heatmaps do
  desc 'Generate a test application'
  task generate: ['engine_cart:generate'] do
  end

  desc 'Run Solr and Blacklight for interactive development'
  task :server, [:rails_server_args] do |_t, args|
    if File.exist? EngineCart.destination
      within_test_app do
        system 'bundle update'
      end
    else
      Rake::Task['engine_cart:generate'].invoke
    end

    with_solr do
      within_test_app do
        system 'RAILS_ENV=development rake blacklight_heatmaps:index:seed'
        system 'bin/dev'
      end
    end
  end
end
