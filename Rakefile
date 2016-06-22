begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

load 'tasks/blacklight_maps.rake'

require 'engine_cart/rake_task'

task default: :spec
