require 'rubygems'

puts(File.expand_path(File.dirname(__FILE__) + '/nanoc-3.0.x/lib'))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../nanoc-3.0.x/lib'))
require 'nanoc3/tasks'

Dir['tasks/**/*.rake'].sort.each { |rakefile| load rakefile }
