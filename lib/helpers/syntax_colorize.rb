module Nanoc3::Helpers

  module SyntaxColorize

    require 'nanoc3/helpers/capturing'
    include Nanoc3::Helpers::Capturing

    def syntax_colorize(lang, type=:ultraviolet, &block)
      # Capture block
      data = capture(&block)

      # Remove whitespace
      lines = data.split("\n")
      min_indent = lines.inject(nil) do |memo, line|
        next memo if line =~ /^\s*$/
        next memo if line !~ /^(\s*)/
        [ memo, $1.size ].compact.min
      end
      lines.each do |line|
        line[0,min_indent] = ''
      end
      data = lines.join("\n")

      # Process
      case type
      when :ultraviolet
        begin
          require 'uv'
          filtered_data = Uv.parse(data, 'xhtml', lang, false, 'amy')
        rescue LoadError
          unless $_WARNED_ABOUT_ULTRAVIOLET
            warn "WARNING: Couldn't load uv; please install the ultraviolet gem. This message will not appear again."
          end
          $_WARNED_ABOUT_ULTRAVIOLET = true

          filtered_data = '<pre class="no-uv">' + h(data) + '</pre>'
        end

        # Convert to HTML
        filtered_data = filtered_data.strip.sub(%r{/ ?>}, '>') # convert to HTML

        # Add missing <code> in <pre>
        filtered_data.sub!(/^\s*(<pre class="[^<]+">)\s*/) { |m| "#{m}<code>" }
        filtered_data.sub!(/\s*(<\/pre>)\s*$/) { |m| "</code>#{m}" }
      when :coderay
        # Find filter
        klass = Nanoc3::Filter.named(:coderay)
        filter = klass.new(@item_rep.assigns)
        
        # Filter captured data
        filtered_data = filter.run(data, :language => lang).strip
      else
        raise ArgumentError, "invalid type: #{type}"
      end

      # Append filtered data to buffer
      buffer = eval('_erbout', block.binding)
      buffer << '<pre><code>' if type == :coderay
      buffer << filtered_data
      buffer << '</code></pre>' if type == :coderay
    end

  end

end
