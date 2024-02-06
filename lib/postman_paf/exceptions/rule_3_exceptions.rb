# frozen_string_literal: true

module PostmanPAF
  module Exceptions
    module WhichException
      # Checks if the whole buildingName String contains an Exception I,
      #   Exception II or Exception III. Then checks if last part of the
      #   buildingName String (AKA numeric part) contains an exception.
      # @param paf_address [Hash] to be converted.
      # @return [Symbol] the Rule 3 conversion exception to apply to the
      #   address based on criteria met.
      def self.exception_to_apply_rule3(paf_address:)
        if contains_digit_as_first_and_last?(paf_address[BUILDING_NAME])
          :exception_i
        elsif contains_digit_as_first_and_penultimate_and_alpha_as_last?(paf_address[BUILDING_NAME])
          :exception_ii
        elsif contains_one_alpha_character?(paf_address[BUILDING_NAME])
          :exception_iii
        else
          building_name_parts = paf_address[BUILDING_NAME].split(' ')
          if building_name_parts.size > 1
            last_part = building_name_parts.last
            if last_part.match?(/\d/)
              PostmanPAF::Exceptions::WhichException.last_part_exception_to_apply(paf_address: paf_address, last_part: last_part)
            else
              :no_exception
            end
          else
            :no_exception
          end
        end
      end
    end
  end
end
