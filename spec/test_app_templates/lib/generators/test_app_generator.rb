require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  def add_gems
    gem 'blacklight', '~> 7.0'

    Bundler.with_clean_env do
      run 'bundle install'
    end
  end

  def run_blacklight_generator
    say_status('warning', 'GENERATING BL', :yellow)

    generate 'blacklight:install', '--devise'
  end

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def install_engine
    generate 'blacklight_heatmaps:install'
  end
end
