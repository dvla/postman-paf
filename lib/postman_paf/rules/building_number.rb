# frozen_string_literal: true

module PostmanPAF
  module Rules
    module ApplyRule
      # Places buildingNumber in converted printable format address depending
      #   on thoroughfare and locality elements present in the PAF address.
      # @param data [Array<String>] the converted lines of address data.
      # @param paf_address [Hash] to be converted.
      # @param number [String] the building number to be placed in the
      #   converted address.
      # @return data [Array<String>] the updated converted lines of
      #   address data with the building number added.
      def self.add_building_number(data:, paf_address:, number:)
        if paf_address[DEPENDENT_THOROUGHFARE_NAME]
          data << "#{number} #{paf_address[DEPENDENT_THOROUGHFARE_NAME]}"
          data << paf_address[THOROUGHFARE_NAME]
          data << paf_address[DOUBLE_DEPENDENT_LOCALITY]
          data << paf_address[DEPENDENT_LOCALITY]
        elsif paf_address[THOROUGHFARE_NAME]
          data << "#{number} #{paf_address[THOROUGHFARE_NAME]}"
          data << paf_address[DOUBLE_DEPENDENT_LOCALITY]
          data << paf_address[DEPENDENT_LOCALITY]
        elsif paf_address[DOUBLE_DEPENDENT_LOCALITY]
          data << "#{number} #{paf_address[DOUBLE_DEPENDENT_LOCALITY]}"
          data << paf_address[DEPENDENT_LOCALITY]
        elsif paf_address[DEPENDENT_LOCALITY]
          data << "#{number} #{paf_address[DEPENDENT_LOCALITY]}"
        else
          data << number
        end
      end
    end
  end
end
