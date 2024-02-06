# frozen_string_literal: true

module PostmanPAF
  module Rules
    module ApplyRule
      # Applies conversion Rule 4 to the PAF address.
      #   Rule 4 conversion criteria: buildingName + buildingNumber OR
      #   organisationName + buildingName + buildingNumber. Exceptions
      #   are not applicable.
      # @param paf_address [Hash] to be converted.
      # @return data [Array<String>] the converted lines of address data.
      def self.apply_rule4(paf_address:)
        data = []

        data << paf_address[ORGANISATION_NAME]
        data << paf_address[DEPARTMENT_NAME]
        data << "PO BOX #{paf_address[PO_BOX_NUMBER]}" if paf_address[PO_BOX_NUMBER]

        data << paf_address[BUILDING_NAME]
        PostmanPAF::Rules::ApplyRule.add_building_number(data: data, paf_address: paf_address, number: paf_address[BUILDING_NUMBER])
      end
    end
  end
end
