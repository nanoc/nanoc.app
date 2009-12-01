# encoding: utf-8

desc 'Removes all stray files from the output directory'
task :clean_all do
  puts '=== Removing stray files from output directory…'

  # Get static files
  static_files = Dir['assets/**/*'].select { |f| File.file?(f) }.map { |f| f.sub(/^assets\//, 'output/') }

  # Get compiled files
  site = Nanoc3::Site.new('.')
  site.load_data
  compiled_files = site.items.map do |item|
    item.reps.map do |rep|
      rep.raw_path
    end
  end.flatten.compact.select { |f| File.file?(f) }

  # Get present files
  present_files = Dir['output/**/*'].select { |f| File.file?(f) }

  # Remove stray files
  stray_files = present_files - static_files - compiled_files
  stray_files.each { |f| FileUtils.rm(f) }

  # TODO Remove empty directories
end
