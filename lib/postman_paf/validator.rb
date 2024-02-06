# frozen_string_literal: true

module PostmanPAF
  # Validator class for user input. Verifies input contains required PAF
  #   address elements for mailing.
  # @see https://www.poweredbypaf.com/wp-content/uploads/2017/07/Latest-Programmers_guide_Edition-7-Version-6.pdf Page 12
  class Validator
    POST_TOWN = 'postTown'
    POSTCODE = 'postcode'

    # @param input the object to be validated.
    # @return Validator object.
    def initialize(input:)
      @input = input
    end

    # Verifies input meets minimum requirements for address conversion.
    # @raise [ArgumentError] if input is not a Hash or Array.
    # @return [nil] if Hash or Array meet address conversion
    #   requirements.
    def validate
      if @input.is_a?(Hash)
        validate_single_address
      elsif @input.is_a?(Array) && @input.size.positive?
        validate_multiple_addresses
      else
        raise ArgumentError, 'Conversion input must be either a hash containing data for an address, or an array of hashes each containing data for an address'
      end
      nil
    end

    private

    # Verifies input of single Hash contains required address elements.
    # @raise [ArgumentError] if Hash is missing required address elements.
    # @return [nil] if Hash contains required address elements.
    def validate_single_address
      raise ArgumentError, "Hash of address data must contain 'postTown' and 'postcode' keys" unless criteria_for_paf_address?(hash: @input)
    end

    # Verifies input of Array contains a Hash as each element and that
    #   each Hash contains required address elements.
    # @raise [ArgumentError] if an Array elements is not a Hash.
    # @raise [ArgumentError] if Hash element is missing required
    #   address elements.
    # @return [nil] if each Array element is a Hash which contains
    #   required PAF address elements.
    def validate_multiple_addresses
      @input.each do |element|
        raise ArgumentError, 'Each address element in the array must be a hash' unless element.is_a?(Hash)

        raise ArgumentError, "Hash of address data must contain 'postTown' and 'postcode' keys" unless criteria_for_paf_address?(hash: element)
      end
    end

    # Checks if postTown and postcode keys exist within a Hash
    #   (Ruby or JSON Hash syntax).
    # @param hash [Hash] the Hash object.
    # @return [Boolean] whether both keys were found.
    def criteria_for_paf_address?(hash:)
      hash = hash.transform_keys { |k| SimpleSymbolize.camelize(k).to_s }
      hash.keys.include?(POST_TOWN) && hash.keys.include?(POSTCODE)
    end
  end
end
