require 'bundler/gem_tasks'
require 'sock/drawer'

namespace :sock do
  desc 'start the sock-drawer server to manage socket connections'
  task :server do
    Sock::Server.new.start!
  end
end

task :spec do
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec)
  rescue LoadError
  end
end

task default: :spec
