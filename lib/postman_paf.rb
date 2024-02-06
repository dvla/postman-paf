# frozen_string_literal: true

require 'json'
require 'logger'
require 'simple_symbolize'

Dir['./lib/postman_paf/**/*.rb'].each do |file|
  require file
end

module PostmanPAF
  # Initialise Logger output.
  LOG = Logger.new($stdout)
  LOG.formatter = proc { |severity, datetime, _progname, msg| "[#{datetime}  #{severity}  PostmanPAF] -- #{msg}\n" }

  # Converts PAF address data to printable format based on Royal Mail
  #   rules and exceptions.
  # @see https://www.poweredbypaf.com/wp-content/uploads/2017/07/Latest-Programmers_guide_Edition-7-Version-6.pdf
  # @param input [Hash, Array<Hash>] PAF address data.
  # @param max_line_length [Integer, String] optional argument to set
  #   max length of printable address lines 1-5.
  # @param logging [Boolean] optional argument to log rule and
  #   exception(s) applied during conversion.
  # @raises [ArgumentError] if invalid input given.
  # @return [Hash, Array<Hash>, nil] converted address data, nil if
  #   conversion data ineligible for conversion.
  def self.convert(input, max_line_length: nil, logging: false)
    Validator.new(input: input).validate

    Converter.new(paf_address_data: input, max_line_length: max_line_length, logging: logging).convert
  end
end
