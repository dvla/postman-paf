# frozen_string_literal: true

module PostmanPAF
  module Exceptions
    module WhichException
      # Checks if last part of the buildingName String (AKA numeric part)
      #   contains an exception. Checks buildingName ONLY - no numeric
      #   part exceptions were found for subBuildingName in testing.
      # @param paf_address [Hash] to be converted.
      # @param last_part [String] the numeric part of the buildingName.
      # @return [Symbol] the exception to apply to the address based
      #   on criteria met by last_part.
      def self.last_part_exception_to_apply(paf_address:, last_part:)
        if last_part.match?(/^\d+$/) && contains_digit_between_0_and_9999?(paf_address[BUILDING_NAME])
          :exception_to_rule
        elsif contains_digit_as_first_and_last?(last_part)
          if contains_address_keyword?(paf_address[BUILDING_NAME])
            :exception_iv
          elsif contains_digits_with_decimals_or_forward_slashes?(paf_address[BUILDING_NAME])
            :exception_v
          else
            :exception_i_numeric_part
          end
        elsif contains_digit_as_first_and_penultimate_and_alpha_as_last?(last_part)
          if contains_address_keyword?(paf_address[BUILDING_NAME])
            :exception_iv
          else
            :exception_ii_numeric_part
          end
        else
          :no_exception
        end
      end
    end
  end
end
