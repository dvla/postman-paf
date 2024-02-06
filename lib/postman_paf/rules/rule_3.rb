# frozen_string_literal: true

module PostmanPAF
  module Rules
    module ApplyRule
      # Applies conversion Rule 3 to the PAF address. Rule 3 conversion
      #   criteria: buildingName OR organisationName + buildingName.
      #   Exceptions can apply to buildingName.
      # @param paf_address [Hash] to be converted.
      # @param exception [Symbol] the exception to be applied during
      #   conversion.
      # @return data [Array<String>] the converted lines of address data.
      def self.apply_rule3(paf_address:, exception:)
        data = []

        data << paf_address[ORGANISATION_NAME]
        data << paf_address[DEPARTMENT_NAME]
        data << "PO BOX #{paf_address[PO_BOX_NUMBER]}" if paf_address[PO_BOX_NUMBER]

        case exception
        when :exception_i, :exception_ii, :exception_iii
          if paf_address[DEPENDENT_THOROUGHFARE_NAME]
            data << "#{paf_address[BUILDING_NAME]} #{paf_address[DEPENDENT_THOROUGHFARE_NAME]}"
            data << paf_address[THOROUGHFARE_NAME]
          else
            data << "#{paf_address[BUILDING_NAME]} #{paf_address[THOROUGHFARE_NAME]}"
          end
        when :exception_i_numeric_part, :exception_ii_numeric_part
          *name, number = paf_address[BUILDING_NAME].split(' ')
          data << name.join(' ')
          PostmanPAF::Rules::ApplyRule.add_building_number(data: data, paf_address: paf_address, number: number)
        else
          # Applies if :exception_to_rule, :exception_iv, :exception_v or :no_exception i.e. buildingName is not split
          data << paf_address[BUILDING_NAME]
          data << paf_address[DEPENDENT_THOROUGHFARE_NAME]
          data << paf_address[THOROUGHFARE_NAME]
        end

        data << paf_address[DOUBLE_DEPENDENT_LOCALITY] unless data.include?(paf_address[DOUBLE_DEPENDENT_LOCALITY])
        data << paf_address[DEPENDENT_LOCALITY] unless data.include?(paf_address[DEPENDENT_LOCALITY])
        data
      end
    end
  end
end
