# frozen_string_literal: true

module PostmanPAF
  module Exceptions
    module WhichException
      # Exception I.
      # @param address_data [String] buildingName or subBuildingName data.
      # @return [Boolean] if first and last characters are numeric.
      # @example
      #   contains_digit_as_first_and_last?("1") #=> true
      #   contains_digit_as_first_and_last?("1-2") #=> true
      #   contains_digit_as_first_and_last?("1/2") #=> true
      #   contains_digit_as_first_and_last?("1 Example House 2") #=> true
      #   contains_digit_as_first_and_last?("1 Example House") #=> false
      def self.contains_digit_as_first_and_last?(address_data)
        address_data.match?(/^\d(.*\d)?$/)
      end

      # Exception II.
      # @param address_data [String] buildingName or subBuildingName data.
      # @return [Boolean] if first and penultimate characters are numeric and
      #   last character is alphabetic. Case insensitive.
      # @example
      #   contains_digit_as_first_and_penultimate_and_alpha_as_last?("1A") #=> true
      #   contains_digit_as_first_and_penultimate_and_alpha_as_last?("12A") #=> true
      #   contains_digit_as_first_and_penultimate_and_alpha_as_last?("1 Example 2A") #=> true
      #   contains_digit_as_first_and_penultimate_and_alpha_as_last?("1") #=> false
      #   contains_digit_as_first_and_penultimate_and_alpha_as_last?("15 A2") #=> false
      def self.contains_digit_as_first_and_penultimate_and_alpha_as_last?(address_data)
        return false unless address_data.length >= 2

        first, *middle, last = address_data.chars

        first.match?(/[[:digit:]]/) &&
          (middle.empty? || middle.last.match?(/[[:digit:]]/)) &&
          last.match?(/[[:alpha:]]/)
      end

      # Exception III.
      # @param address_data [String] buildingName or subBuildingName data.
      # @return [Boolean] if one alphabetic character only. Case insensitive.
      # @example
      #   contains_one_alpha_character?("A") #=> true
      #   contains_one_alpha_character?("b") #=> true
      #   contains_one_alpha_character?("Z") #=> true
      #   contains_one_alpha_character?("1") #=> false
      def self.contains_one_alpha_character?(address_data)
        return false unless address_data.length.eql? 1

        address_data.match?(/^[a-zA-Z]$/)
      end

      # Exception to Rule.
      # @param address_data [String] buildingName.
      # @return [Boolean] if last part (i.e. numeric part) contains a number
      #   between 0 and 9999.
      # @example
      #   contains_digit_between_0_and_9999?("Example 0") #=> true
      #   contains_digit_between_0_and_9999?("Example 14") #=> true
      #   contains_digit_between_0_and_9999?("Example 9999") #=> true
      #   contains_digit_between_0_and_9999?("Example 10000") #=> false
      def self.contains_digit_between_0_and_9999?(address_data)
        address_data.match?(/ \d{1,4}$/)
      end

      # Exception IV.
      # @param address_data [String] buildingName.
      # @return [Boolean] if last part (i.e. numeric range or a numeric alpha
      #   suffix) is prefixed by an addressing keyword. Case insensitive.
      # @example
      #   contains_address_keyword?("UNIT 1") #=> true
      #   contains_address_keyword?("BLOCKS 1-2") #=> true
      #   contains_address_keyword?("FLAT 12A") #=> true
      #   contains_address_keyword?("shops 2-4") #=> true
      #   contains_address_keyword?("STALLS") #=> false
      def self.contains_address_keyword?(address_data)
        last_part = address_data.split(' ').last

        ['BACK OF', 'BLOCK', 'BLOCKS', 'BUILDING', 'FLAT', 'MAISONETTE', 'MAISONETTES', 'REAR OF', 'SHOP', 'SHOPS', 'STALL',
         'STALLS', 'SUITE', 'SUITES', 'UNIT', 'UNITS'].each do |keyword|
          regex = "(^|\\s)#{keyword} #{last_part.upcase}$"
          return true if address_data.upcase.match?(regex)
        end
        false
      end

      # Exception V.
      # @param address_data [String] buildingName.
      # @return [Boolean] if penultimate part (i.e. word in a buildingName) is
      #   followed by a whitespace and completed by numerics with decimals or
      #   forward slashes.
      # @example
      #   contains_digits_with_decimals_or_forward_slashes?("Example 1.2") #=> true
      #   contains_digits_with_decimals_or_forward_slashes?("Example 85/1") #=> true
      #   contains_digits_with_decimals_or_forward_slashes?("Example 7:8") #=> false
      def self.contains_digits_with_decimals_or_forward_slashes?(address_data)
        last_part = address_data.split(' ').last

        last_part.match?(%r{^\d+[.|/]\d+$})
      end
    end
  end
end
