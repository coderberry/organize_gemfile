module OrganizeGemfile
  class BundleParser
    def initialize(gemfile_path, gemfile_lock_path)
      @gemfile_path = gemfile_path
      @gemfile_lock_path = gemfile_lock_path
      @dsl = Bundler::Definition.build(@gemfile_path, @gemfile_lock_path, {})
      @requires = @dsl.requires
      @sources = sources
    end

    def groups
      ret = {}

      before_default = @sources.select { |source| source[:appear_at_top] == true }
      if before_default.any?
        ret["before_default"] = GemfileGroup.new(:before_default, before_default)
      end

      @sources.reject { |source| source[:appear_at_top] == true }
        .group_by { |source| source[:groups] }
        .map do |group, sources|
        ret[group.map(&:to_s).join("_")] = GemfileGroup.new(group, sources)
      end

      ret
    end

    def ruby_version
      @dsl.ruby_version&.versions&.first
    end

    private

    def sources
      specs = Gem.loaded_specs

      @dsl.dependencies.map do |dep|
        spec = specs.key?(dep.name) ? specs[dep.name] : nil
        spec = spec&.to_spec

        {
          name: dep.name,
          summary: spec&.summary,
          homepage: spec&.homepage,
          groups: dep.groups,
          git: dep.git,
          branch: dep.branch,
          platforms: dep.platforms,
          gemfile: dep.gemfile,
          version: dep.requirement.to_s,
          source: dep.source,
          requires: @requires[dep.name],
          appear_at_top: @requires[dep.name].include?("dotenv/rails-now")
        }
      end
    end
  end
end
