begin ; require 'rubygems' ; rescue LoadError ; end
require 'nanoc'

desc 'removes all compiled pages from the output directory'
task :clean do
  # Load site
  site = Nanoc::Site.from_cwd rescue Nanoc::Site.new(YAML.load_file('config.yaml'))
  site.load_data

  # Get reps
  reps = (site.pages + site.assets).map { |p| p.reps }.flatten

  # Remove all compiled pages
  reps.map { |r| r.disk_path }.each do |path|
    FileUtils.remove_entry_secure(path) if File.file?(path)
  end
end
