require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'simplecov'
require 'simplecov-console'

include RspecPuppetFacts

RSpec.configure do |config|
  config.hiera_config = File.expand_path(
    File.join(__FILE__, '../fixtures/hiera.yaml')
  )
  config.confdir = '/etc/puppetlabs/puppet'
  config.formatter = :documentation
  config.color = true
  config.tty = true
end

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