Nanoc::Filter.define(:autoprefixer) do |content, _params|
  result = Fiber.yield(proc { AutoprefixerRails::Processor.new.process(content) })
  if result.warnings.any?
    $stderr.puts "autoprefixer warnings for #{@item_rep.inspect}:"
    $stderr.puts result.warnings.map { |w| '  ' + w }.join("\n")
  end
  result.css
end
