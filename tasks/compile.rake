task :copy_assets do
  system "rsync -gprt --partial --exclude='.svn' assets/ output"
end

task :compile do
  system "nanoc3 co"
end

task :default => [ :compile, :copy_assets ]
