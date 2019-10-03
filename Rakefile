# coding: utf-8


require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks :name => "tools"

#require 'bundler/gem_tasks'
require_relative 'lib/tools/version'


# Default.
task :default => :help

# Help.
desc 'Help'
task :help do
  system('rake -T')
end

desc 'Makes you a tools developer'
task :dev do
  if ENV['GEM_HOME'].nil?
    puts 'Environment variable GEM_HOME is empty, you should be using RVM for ths task to work.'
    exit(1)
  end

  Rake::Task['install'].invoke

  source = File.dirname(File.absolute_path __FILE__)
  target = "#{ENV['GEM_HOME']}/gems/tools-#{Tools::VERSION}"
  target_bin = "#{ENV['GEM_HOME']}/bin/tools"
  system("rm -f #{target_bin}")
  system("rm -rf #{target}")
  system("ln -s #{source} #{target}")
  system("ln -s #{source}/bin/tools #{target_bin}")

  puts 'You may now start editing and testing files from within this repo.'
end


desc "Release the gem in Artifactory (DEV)"
task :push do
  gem_file   = "#{ENV['PWD']}/pkg/tools-#{Tools::VERSION}.gem"
  gem_server_url = 'https://rubygems.org'
  system("gem push #{gem_file}  --host #{gem_server_url}")
end


desc "Run all minitests."
task :mini do
  system("./test/minitest/run")
end