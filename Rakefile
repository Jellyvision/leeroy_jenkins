require 'bundler/gem_tasks'

desc 'Lint, run unit tests, and run acceptance tests.'
task :verify => [:rubocop, :rspec, :cucumber]

desc 'Lint.'
task :rubocop do
  sh 'bundle exec rubocop'
end

desc 'Run unit tests.'
task :rspec do
  sh 'bundle exec rspec'
end

desc 'Run acceptance tests.'
task :cucumber do
  sh 'bundle exec cucumber'
end

task :default => :verify
