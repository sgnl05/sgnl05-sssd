source ENV['GEM_SOURCE'] || 'https://rubygems.org'

if (facterversion = ENV['FACTER_GEM_VERSION'])
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if (puppetversion = ENV['PUPPET_GEM_VERSION'])
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

group :unit_tests do
  gem 'puppet-lint-absolute_classname-check',             :require => false
  gem 'puppet-lint-absolute_template_path',               :require => false
  gem 'puppet-lint-appends-check',                        :require => false
  gem 'puppet-lint-empty_string-check',                   :require => false
  gem 'puppet-lint-file_ensure-check',                    :require => false
  gem 'puppet-lint-leading_zero-check',                   :require => false
  gem 'puppet-lint-spaceship_operator_without_tag-check', :require => false
  gem 'puppet-lint-strict_indent-check',                  :require => false
  gem 'puppet-lint-trailing_comma-check',                 :require => false
  gem 'puppet-lint-trailing_newline-check',               :require => false
  gem 'puppet-lint-undef_in_function-check',              :require => false
  gem 'puppet-lint-unquoted_string-check',                :require => false
  gem 'puppet-lint-variable_contains_upcase',             :require => false
  gem 'puppet-lint-version_comparison-check',             :require => false
  gem 'puppetlabs_spec_helper',                           :require => false
  gem 'rspec-puppet-facts',                               :require => false
end

group :development do
  gem 'simplecov', :require => false
  # gem 'guard-rake',       :require => false
  gem 'librarian-puppet', :require => false
end

group :system_tests do
  # gem 'vagrant-wrapper', :require => false
  gem 'serverspec', :require => false
end

if puppetversion && puppetversion < '5.0'
  gem 'semantic_puppet', :require => false
end

gem 'metadata-json-lint',     :require => false
gem 'public_suffix', '1.4.6', :require => false
gem 'puppet-strings',         :require => false

if RUBY_VERSION < '2.2.5'
  # beaker 3.1+ requires ruby 2.2.5.  Lock to 2.0
  gem 'beaker', '~> 2.0', :require => false
  # beaker-rspec 6.0.0 requires beaker 3.0. Lock to 5.6.0
  gem 'beaker-rspec', '= 5.6.0', :require => false
end

# vim:ft=ruby
