require "bundler/gem_tasks"
require 'frepl'

task :console do
  require 'pry'
  require 'frepl'

  def reload!
    files = $LOADED_FEATURES.select { |feat| feat =~ /\/frepl\// }
    files.each { |file| load file }
  end

  ARGV.clear
  Pry.start
end
