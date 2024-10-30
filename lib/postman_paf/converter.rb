# frozen_string_literal: true

module PostmanPAF
  # Converter class for converting validated PAF addresses to printable
  #   format addresses using applicable Royal Mail rules and exceptions.
  class Converter
    POST_TOWN = 'postTown'
    POSTCODE = 'postcode'

    # @param paf_address_data [Hash, Array<Hash>] to be converted.
    # @param max_line_length [Integer, String] optional argument to set max
    #   length of printable address lines 1-5.
    # @param logging [Boolean] optional argument for logging of rules and
    #   exceptions applied to address during conversion.
    # @return Converter object.
    def initialize(paf_address_data:, max_line_length: nil, logging: false)
      @paf_address_data = paf_address_data.is_a?(Array) ? paf_address_data : [paf_address_data]
      @max_line_length = if max_line_length.is_a?(Integer) || max_line_length.is_a?(String)
                           max_line_length.to_i.positive? ? max_line_length.to_i : nil
                         end
      @logging = logging.is_a?(TrueClass)
    end

    # Handles conversion of single or multiple PAF addresses (i.e. single
    #   Hash or Array of Hashes) - in both cases Hash keys are sanitised
    #   in case of newer JSON-style syntax, where Ruby stores keys as
    #   symbols.
    # @return [Hash, Array<Hash>, nil] converted address data as JSON Hash
    #   or nil if invalid PAF address data is provided.
    def convert
      converted_addresses = @paf_address_data.map { |address| address.transform_keys { |k| SimpleSymbolize.camelize(k).to_s } }
                                             .map { |address| paf_to_printable(paf_address: address) }

      converted_addresses.count.eql?(1) ? converted_addresses.pop : converted_addresses
    end

  private

    # Converts a single PAF address to printable format after determining
    #   applicable rule and exception(s). Truncation and logging optional.
    # @param paf_address [Hash] to be converted.
    # @return [Hash] converted address data as JSON Hash.
    def paf_to_printable(paf_address:)
      rule = PostmanPAF::Rules.which_rule(paf_address: paf_address)
      exception = PostmanPAF::Exceptions.which_exception(rule: rule, paf_address: paf_address)
      lines = PostmanPAF::Rules.apply_rule(rule: rule, paf_address: paf_address, exception: exception).compact

      lines[4] = paf_address[POST_TOWN]

      if @max_line_length
        lines = lines.map do |line|
          if line.nil?
            line
          else
            line.slice(0..(@max_line_length - 1))
          end
        end
      end

      LOG.info("#{lines.compact} | #{rule} | #{exception} | #{paf_address[POSTCODE]}") if @logging

      PostmanPAF::Rules::BuildAddress.build_printable_address(paf_address: paf_address, lines: lines)
    end
  end
end
