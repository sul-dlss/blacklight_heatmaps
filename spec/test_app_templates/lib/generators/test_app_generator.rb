require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  def add_gems
    gem 'blacklight', ENV.fetch('BLACKLIGHT_VERSION', '~> 8.0')

    Bundler.with_clean_env do
      run 'bundle install'
    end
  end

  # This makes the assets available in the test app so that changes made in
  # local development can be picked up automatically
  def link_frontend
    inside('..') do
      run 'yarn unlink ; yarn link'
    end
  end

  def run_blacklight_generator
    say_status('warning', 'GENERATING BL', :yellow)

    generate 'blacklight:install'
  end

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def install_engine
    generate 'blacklight_heatmaps:install', '--test'
  end
end
