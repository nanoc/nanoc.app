# encoding: utf-8

desc 'Removes all stray files from the output directory'
task :clean_all do
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
  stray_files = present_files - compiled_files
  stray_files.each { |f| FileUtils.rm(f) }

  # Remove empty directories
  loop do
    changed = false
    Dir['output/**/*'].select { |f| File.directory?(f) }.each do |dir|
      is_empty = !Dir.foreach(dir) { |n| break true if n !~ /\A\.\.?\z/ }
      next if !is_empty

      puts "Deleting empty directory #{dir}"
      Dir.rmdir(dir)
      changed = true
    end
    break if !changed
  end
end
