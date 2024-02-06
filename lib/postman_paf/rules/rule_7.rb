# frozen_string_literal: true

module PostmanPAF
  module Rules
    module ApplyRule
      # Applies conversion Rule 7 to the PAF address. Rule 7 conversion
      #   criteria: subBuildingName + buildingName + buildingNumber OR
      #   organisationName + subBuildingName + buildingName +
      #   buildingNumber. Exceptions can apply to subBuildingName ONLY.
      # @param paf_address [Hash] to be converted.
      # @param exception [Symbol] the exception to be applied during
      #   conversion.
      # @return data [Array<String>] the converted lines of address data.
      def self.apply_rule7(paf_address:, exception:)
        data = []

        data << paf_address[ORGANISATION_NAME]
        data << paf_address[DEPARTMENT_NAME]
        data << "PO BOX #{paf_address[PO_BOX_NUMBER]}" if paf_address[PO_BOX_NUMBER]

        case exception
        when :exception_i, :exception_ii, :exception_iii
          data << "#{paf_address[SUB_BUILDING_NAME]} #{paf_address[BUILDING_NAME]}"
        else
          data << paf_address[SUB_BUILDING_NAME]
          data << paf_address[BUILDING_NAME]
        end

        PostmanPAF::Rules::ApplyRule.add_building_number(data: data, paf_address: paf_address, number: paf_address[BUILDING_NUMBER])
      end
    end
  end
end
