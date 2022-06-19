# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

GEM_NAME = "organize_gemfile"
GEM_VERSION = OrganizeGemfile::VERSION

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

require "standard/rake"

task default: %i[test standard]

task :build do
  system "gem build #{GEM_NAME}.gemspec"
end

task :install => :build do
  system "gem install #{GEM_NAME}-#{GEM_VERSION}.gem"
end

task :publish => :build do
  system "gem push #{GEM_NAME}-#{GEM_VERSION}.gem"
end

task :clean do
  system "rm *.gem"
end