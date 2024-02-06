# frozen_string_literal: true

module PostmanPAF
  module Rules
    module ApplyRule
      # Applies conversion Rule 1 to the PAF address.
      #   Rule 1 conversion criteria: organisationName.
      #   Will also apply as a default if organisationName,
      #   subBuildingName, buildingName + buildingNumber NOT
      #   present. Exceptions are not applicable.
      # @param paf_address [Hash] to be converted.
      # @return data [Array<String>] the converted lines of address data.
      def self.apply_rule1(paf_address:)
        data = []

        data << paf_address[ORGANISATION_NAME]
        data << paf_address[DEPARTMENT_NAME]
        data << "PO BOX #{paf_address[PO_BOX_NUMBER]}" if paf_address[PO_BOX_NUMBER]

        data << paf_address[DEPENDENT_THOROUGHFARE_NAME]
        data << paf_address[THOROUGHFARE_NAME]
        data << paf_address[DOUBLE_DEPENDENT_LOCALITY]
        data << paf_address[DEPENDENT_LOCALITY]
      end
    end
  end
end
