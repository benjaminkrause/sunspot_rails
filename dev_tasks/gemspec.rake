begin
  gem 'technicalpickles-jeweler', '~> 0.8.1'
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'sunspot_rails'
    s.summary = 'Rails integration for the Sunspot Solr search library'
    s.email = 'mat@patch.com'
    s.homepage = 'http://github.com/outoftime/sunspot_rails'
    s.description = 'Rails integration for the Sunspot Solr search library'
    s.authors = ['Mat Brown']
    s.files = FileList['[A-Z]*', '{lib,spec,tasks,dev_tasks}/**/*', 'install.rb', 'MIT-LICENSE', 'rails']
    s.add_dependency 'rails', '~> 2.1'
    s.add_dependency 'escape', '>= 0.0.4'
    s.add_dependency 'outoftime-sunspot', '>= 0.7.2'
    s.add_development_dependency 'rspec', '~> 1.2'
    s.add_development_dependency 'rspec-rails', '~> 1.2'
    s.add_development_dependency 'ruby-debug', '~> 0.10'
    s.add_development_dependency 'technicalpickles-jeweler', '~> 0.8'
  end
end