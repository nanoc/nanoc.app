begin ; require 'rubygems' ; rescue LoadError ; end
require 'nanoc'

desc 'removes all generated output files from the output directory'
task :clean do
  # Load site
  site = Nanoc::Site.new(YAML.load_file('config.yaml'))
  site.load_data

  # Get reps
  reps = (site.pages + site.assets).map { |o| o.reps }.flatten

  # Remove all compiled pages
  reps.map { |r| r.disk_path }.each do |path|
    FileUtils.rm(path) if File.file?(path)
  end
end
