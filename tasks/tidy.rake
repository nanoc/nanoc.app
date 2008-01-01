require 'rubygems'
require 'tidy'

task :tidy do
  puts '===== TIDYING'

  # config
  show_warnings = false
  Tidy.path     = '/usr/lib/libtidy.dylib'

  # validate
  errors = Dir['output/**/*.html'].inject({}) do |memo, filename|
    Tidy.open(:show_warnings => show_warnings) do |tidy|
      tidy.clean(File.read(filename))
      memo.merge(filename => tidy.errors)
    end
  end

  # dislay result
  if errors.values.flatten.empty?
    puts 'No errors.'
  else
    errors.each_pair do |filename, errors|
      puts "#{filename}:"
      puts errors.join
      puts
    end
  end
end
