# frozen_string_literal: true

module PostmanPAF
  module Exceptions
    module WhichException
      RULE6_PREMISE_ELEMENTS = %w[buildingName subBuildingName].freeze

      # Checks if the whole buildingName String contains an Exception I,
      #   Exception II or Exception III. Then checks if last part of the
      #   buildingName String (AKA numeric part) contains an exception.
      #   Finally checks if the whole subBuildingName String contains an
      #   Exception I, Exception II or Exception III.
      # @param paf_address [Hash] to be converted.
      # @return [Symbol] the Rule 6 conversion exception(s) to apply to
      #   the address based on criteria met.
      def self.exception_to_apply_rule6(paf_address:)
        RULE6_PREMISE_ELEMENTS.each_with_object([]) do |premise_element, exceptions|
          exception = if contains_digit_as_first_and_last?(paf_address[premise_element])
                        :exception_i
                      elsif contains_digit_as_first_and_penultimate_and_alpha_as_last?(paf_address[premise_element])
                        :exception_ii
                      elsif contains_one_alpha_character?(paf_address[premise_element])
                        :exception_iii
                      elsif premise_element == BUILDING_NAME
                        # Checks buildingName ONLY for numeric part exception - no numeric part
                        #   exceptions have been found for subBuildingName in test data.
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
                      else
                        :no_exception
                      end

          premise_element_exception = "#{SimpleSymbolize.snakeize(premise_element)}_#{exception}".to_sym
          exceptions << premise_element_exception
        end
      end
    end
  end
end
