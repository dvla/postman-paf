# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  SimpleCov.minimum_coverage 100
  SimpleCov.track_files 'lib/**/*.rb'
  SimpleCov.add_filter 'lib/postman_paf/version.rb'
  SimpleCov.add_filter '/spec'
end

require 'hash_miner'
require 'logger'
require 'pry'
require 'postman_paf'
require 'simple_symbolize'

PAF_ADDRESS = 'paf'
PRINTABLE_ADDRESS = 'printable'
INVALID_INPUT_TYPE_MSG =
  'Conversion input must be either a hash containing data for an address, or an array of hashes each containing data for an address'
MISSING_REQUIRED_HASH_KEYS_MSG = "Hash of address data must contain 'postTown' and 'postcode' keys"
INVALID_INPUT_ARRAY_MSG = 'Each address element in the array must be a hash'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
