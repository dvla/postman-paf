# frozen_string_literal: true

module PostmanPAF
  module Rules
    module ApplyRule
      SUB_BUILDING_NAME_EXCEPTIONS = %i[sub_building_name_exception_i sub_building_name_exception_ii sub_building_name_exception_iii].freeze

      # Applies conversion Rule 6 to the PAF address. Rule 6 conversion
      #   criteria: subBuildingName + buildingName OR organisationName
      #   + subBuildingName + buildingName. Exceptions can apply to
      #   subBuildingName AND/OR buildingName.
      # @param paf_address [Hash] to be converted.
      # @param exceptions [Array<Symbol>] the exceptions to be applied
      #   during conversion.
      # @return data [Array<String>] the converted lines of address data.
      def self.apply_rule6(paf_address:, exceptions:)
        building_name_exception = exceptions.first
        sub_building_name_exception = exceptions.last

        data = []

        data << paf_address[ORGANISATION_NAME]
        data << paf_address[DEPARTMENT_NAME]
        data << "PO BOX #{paf_address[PO_BOX_NUMBER]}" if paf_address[PO_BOX_NUMBER]

        case building_name_exception
        when :building_name_exception_i, :building_name_exception_ii, :building_name_exception_iii
          # Applies regardless of sub_building_name_exception.
          if paf_address[DEPENDENT_THOROUGHFARE_NAME]
            data << paf_address[SUB_BUILDING_NAME]
            data << "#{paf_address[BUILDING_NAME]} #{paf_address[DEPENDENT_THOROUGHFARE_NAME]}"
            data << paf_address[THOROUGHFARE_NAME]
          else
            data << paf_address[SUB_BUILDING_NAME]
            data << "#{paf_address[BUILDING_NAME]} #{paf_address[THOROUGHFARE_NAME]}"
          end
        when :building_name_exception_i_numeric_part, :building_name_exception_ii_numeric_part
          if SUB_BUILDING_NAME_EXCEPTIONS.include?(sub_building_name_exception)
            *name, number = paf_address[BUILDING_NAME].split(' ')
            data << "#{paf_address[SUB_BUILDING_NAME]} #{name.join(" ")}"
            PostmanPAF::Rules::ApplyRule.add_building_number(data: data, paf_address: paf_address, number: number)
          else
            *name, number = paf_address[BUILDING_NAME].split(' ')
            data << paf_address[SUB_BUILDING_NAME]
            data << name.join(' ')
            PostmanPAF::Rules::ApplyRule.add_building_number(data: data, paf_address: paf_address, number: number)
          end
        else
          # Applies if :building_name_exception_to_rule, :building_name_exception_iv, :building_name_exception_v or :building_name_no_exception
          # i.e. buildingName is not split
          if SUB_BUILDING_NAME_EXCEPTIONS.include?(sub_building_name_exception)
            data << "#{paf_address[SUB_BUILDING_NAME]} #{paf_address[BUILDING_NAME]}"
            data << paf_address[DEPENDENT_THOROUGHFARE_NAME]
            data << paf_address[THOROUGHFARE_NAME]
          else
            data << paf_address[SUB_BUILDING_NAME]
            data << paf_address[BUILDING_NAME]
            data << paf_address[DEPENDENT_THOROUGHFARE_NAME]
            data << paf_address[THOROUGHFARE_NAME]
          end
        end

        data << paf_address[DOUBLE_DEPENDENT_LOCALITY] unless data.include?(paf_address[DOUBLE_DEPENDENT_LOCALITY])
        data << paf_address[DEPENDENT_LOCALITY] unless data.include?(paf_address[DEPENDENT_LOCALITY])
        data
      end
    end
  end
end
