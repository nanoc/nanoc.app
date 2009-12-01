# encoding: utf-8

task :copy_assets do
  puts '=== Copying assets…'
  system "rsync -gprt --partial assets/ output"
end

task :compile do
  puts '=== Compiling…'
  system "nanoc3 co"
end

task :default => [ :clean_all, :copy_assets, :compile ]
