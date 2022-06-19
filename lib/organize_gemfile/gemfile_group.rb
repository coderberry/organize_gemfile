module OrganizeGemfile
  class GemfileGroup < Struct.new(:name, :specs)
    def initialize(name, specs = [])
      super
    end

    def to_gemfile_lines
      lines = []
      indent_spaces = ""
      max_length = 0

      is_before_default = name == :before_default
      is_default = name == [:default]

      if !is_before_default && !is_default
        indent_spaces = "  "
        lines << "group #{name.map { |n| ":#{n}" }.join(", ")} do"
      end

      spec_lines = specs.sort_by { |s| s[:name] }.map do |spec|
        parts = []
        parts << "gem \"#{spec[:name]}\""
        parts << "\"#{spec[:version]}\"" if spec[:version] && spec[:version] != ">= 0"
        parts << "require: \"#{spec[:requires].first}\"" if spec[:requires].first && spec[:requires].first != spec[:name]
        parts << "require: false" if spec[:requires] == []
        parts << "platforms: %i[ #{spec[:platforms].join(" ")} ]" if spec[:platforms].any?
        line = parts.join(", ")

        if spec[:summary]
          max_length = [max_length, line.length].max
        end

        {line: line, spec: spec}
      end

      spec_lines.each do |l|
        line = l[:line]
        spec = l[:spec]

        if spec[:summary]
          line = line.ljust(max_length)
          line += " # #{spec[:summary]}"
        end
        lines << indent_spaces + line
      end

      if !is_before_default && !is_default
        lines << "end"
      end

      lines
    end
  end
end
