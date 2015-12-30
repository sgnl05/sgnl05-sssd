require 'rubygems' if RUBY_VERSION < '1.9.0'
# require 'rubocop/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'

# RuboCop::RakeTask.new

exclude_paths = [
  'modules/**/*',
  'pkg/**/*',
  'spec/**/*',
  'vendor/**/*'
]

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.relative = true
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

Rake::Task[:default].prerequisites.clear
task :default => :all

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run RuboCop'
task :rubocop do
  sh 'rubocop'
end

desc 'Clean up modules / pkg'
task :clean do
  sh 'rm -rf modules pkg spec/fixtures'
end

task :success do
  puts "\n\e[32mAll tests passing...\e[0m"
end

desc 'Run all'
task :all => [
  :clean,
  :test,
  :success
]

desc 'Run rubocop, syntax, lint, and spec tests'
task :test => [
  :rubocop,
  :syntax,
  :lint,
  :metadata_lint,
  :spec
]
