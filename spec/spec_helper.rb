require 'simplecov'
require 'simplecov-console'
SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::Console
    ]
  )
end

require 'puppetlabs_spec_helper/module_spec_helper'

require 'rspec-puppet-facts'
include RspecPuppetFacts

fixtures_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

# RSpec configuration
RSpec.configure do |config|
  config.tty = true
  config.color = true
  config.formatter = :documentation
  config.trusted_node_data = true
  config.module_path = File.join(fixtures_path, 'modules')
  config.manifest_dir = File.join(fixtures_path, 'manifests')
  config.hiera_config = File.join(fixtures_path, 'hiera.yaml')
  config.after(:suite) { RSpec::Puppet::Coverage.report! }
end