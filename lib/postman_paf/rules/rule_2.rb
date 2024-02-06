# frozen_string_literal: true

module PostmanPAF
  module Rules
    module ApplyRule
      # Applies conversion Rule 2 to the PAF address.
      #   Rule 2 conversion criteria: buildingNumber OR
      #   organisationName + buildingNumber. Exceptions
      #   are not applicable.
      # @param paf_address [Hash] to be converted.
      # @return data [Array<String>] the converted lines of address data.
      def self.apply_rule2(paf_address:)
        data = []

        data << paf_address[ORGANISATION_NAME]
        data << paf_address[DEPARTMENT_NAME]
        data << "PO BOX #{paf_address[PO_BOX_NUMBER]}" if paf_address[PO_BOX_NUMBER]

        PostmanPAF::Rules::ApplyRule.add_building_number(data: data, paf_address: paf_address, number: paf_address[BUILDING_NUMBER])
      end
    end
  end
end
