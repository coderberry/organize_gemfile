# frozen_string_literal: true

require_relative "organize_gemfile/bundle_parser.rb"
require_relative "organize_gemfile/gemfile_group.rb"
require_relative "organize_gemfile/builder.rb"
require_relative "organize_gemfile/version"

module OrganizeGemfile
  class Error < StandardError; end

  def self.execute
    gemfile_path = File.expand_path("Gemfile")
    raise "Gemfile not found" unless File.exist?(gemfile_path)

    gemfile_lock_path = File.expand_path("Gemfile.lock")
    raise "Gemfile.lock not found" unless File.exist?(gemfile_lock_path)

    parser = BundleParser.new(gemfile_path, gemfile_lock_path)
    ruby_version = parser.ruby_version
    groups = parser.groups
    builder = Builder.new(gemfile_path, ruby_version: ruby_version, groups: groups)
    builder.build
  end
end
