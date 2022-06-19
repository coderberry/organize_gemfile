module OrganizeGemfile
  class Builder
    attr_accessor :lines

    def initialize(gemfile_path, ruby_version:, groups:)
      @gemfile_path = gemfile_path
      @ruby_version = ruby_version
      @groups = groups
      new_gemfile_code = build
    end

    def build
      lines = []
      lines << "source \"https://rubygems.org\""
      lines << "git_source(:github) { |repo| \"https://github.com/\#{repo}.git\" }"
      lines << ""
      lines << "ruby \"#{@ruby_version}\""
      lines << ""

      before_default_group = @groups["before_default"]
      if before_default_group
        lines << before_default_group.to_gemfile_lines
        lines << ""
      end

      default_group = @groups["default"]
      if default_group
        lines << default_group.to_gemfile_lines
        lines << ""
      end

      @groups.select { |name, _group| name != "before_default" && name != "default" }.each do |_name, group|
        lines << group.to_gemfile_lines
        lines << ""
      end

      lines.join("\n")
    end

    def available_groups
      @groups.keys
    end

    def default_group
      @groups["default"]
    end
  end
end