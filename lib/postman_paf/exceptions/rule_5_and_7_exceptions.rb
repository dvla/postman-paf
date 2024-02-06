# frozen_string_literal: true

module PostmanPAF
  module Exceptions
    module WhichException
      # Checks if the whole subBuildingName String contains an Exception I,
      #   Exception II or Exception III.
      # @param paf_address [Hash] to be converted.
      # @return [Symbol] the Rule 5 or Rule 7 conversion exception to apply
      #   to the address based on criteria met.
      def self.exception_to_apply_rule5_rule7(paf_address:)
        if contains_digit_as_first_and_last?(paf_address[SUB_BUILDING_NAME])
          :exception_i
        elsif contains_digit_as_first_and_penultimate_and_alpha_as_last?(paf_address[SUB_BUILDING_NAME])
          :exception_ii
        elsif contains_one_alpha_character?(paf_address[SUB_BUILDING_NAME])
          :exception_iii
        else
          :no_exception
        end
      end
    end
  end
end
