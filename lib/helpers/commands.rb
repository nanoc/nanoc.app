# frozen_string_literal: true

module NanocSite
  module Commands
    def dmark_options_for(cmd)
      return '' unless cmd[:option_definitions]&.any?

      (+'').tap do |buf|
        buf << '#dl' << "\n"
        cmd[:option_definitions].each do |opt_def|
          dmark_desc = ::Kramdown::Document.new(opt_def.desc).to_nanoc_ws_dmark

          buf << '  #dt %command{'
          buf << '-' << opt_def.short if opt_def.short
          buf << ' ' if opt_def.short && opt_def.long
          buf << '--' << opt_def.long if opt_def.long
          buf << '}' << "\n"

          buf << '  #dd' << "\n"
          buf << dmark_desc.lines.map { |l| '    ' + l }.join("\n") << "\n"
        end
      end
    end
  end
end
