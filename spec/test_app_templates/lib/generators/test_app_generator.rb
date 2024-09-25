require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  def add_gems
    gem 'blacklight', ENV.fetch('BLACKLIGHT_VERSION', '~> 7.0')

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

  # Temporarily force js assets to fall back to sprockets
  def clean_up_js_builds
    return unless File.exist?('app/assets/builds')

    append_to_file 'app/assets/config/manifest.js', "\n//= link application.js\n" if File.exist?('app/assets/config/manifest.js')
    gsub_file 'app/assets/config/manifest.js', '//= link_tree ../builds', ''
    remove_dir 'app/assets/builds'
  end
end
