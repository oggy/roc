begin
  require 'cucumber/rake/task'
rescue LoadError
  missing = true
end

unless missing

remove_task :features
Cucumber::Rake::Task.new(:features) do |t|
  t.libs << 'lib' << 'spec'
  t.cucumber_opts = "--format progress"
end

end
