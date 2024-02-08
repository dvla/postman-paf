# frozen_string_literal: true

require 'json'
require 'logger'
require 'simple_symbolize'

require_relative 'postman_paf/exceptions/exceptions'
require_relative 'postman_paf/exceptions/last_part_exceptions'
require_relative 'postman_paf/exceptions/rule_3_exceptions'
require_relative 'postman_paf/exceptions/rule_5_and_7_exceptions'
require_relative 'postman_paf/exceptions/rule_6_exceptions'
require_relative 'postman_paf/exceptions/which_exception'
require_relative 'postman_paf/rules/address_builder'
require_relative 'postman_paf/rules/building_number'
require_relative 'postman_paf/rules/rule_1'
require_relative 'postman_paf/rules/rule_2'
require_relative 'postman_paf/rules/rule_3'
require_relative 'postman_paf/rules/rule_4'
require_relative 'postman_paf/rules/rule_5'
require_relative 'postman_paf/rules/rule_6'
require_relative 'postman_paf/rules/rule_7'
require_relative 'postman_paf/rules/rules'
require_relative 'postman_paf/rules/which_rule'
require_relative 'postman_paf/converter'
require_relative 'postman_paf/printable_address'
require_relative 'postman_paf/validator'
require_relative 'postman_paf/version'

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
