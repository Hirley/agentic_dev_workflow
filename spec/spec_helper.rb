# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'faker'
require 'shoulda-matchers'

Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
