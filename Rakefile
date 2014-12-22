require "bundler/gem_tasks"

task :default => :spec

desc 'Run specs.'
task :spec do
  sh %q[COVERAGE=1 bundle exec rspec]
end

