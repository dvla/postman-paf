# frozen_string_literal: true

module PostmanPAF
  module Rules
    module BuildAddress
      # Builds PrintableAddress object and returns attributes as JSON.
      # @param paf_address [Hash] to be converted.
      # @param lines [Array<String>] the converted lines of address data.
      #   Lines with an Integer value are type converted to a String.
      #   Lines with a value of nil are removed before converted address
      #   is returned.
      def self.build_printable_address(paf_address:, lines:)
        printable_address = PrintableAddress.new

        lines.each_with_index do |line, index|
          line_number = index + 1
          line = line.to_s if line.is_a?(Integer)
          printable_address.send(:"line#{line_number}=", line) if line_number.between?(1, 5)
        end

        printable_address.postcode = paf_address[POSTCODE]
        printable_address.country = paf_address[COUNTRY]
        printable_address.language = paf_address[LANGUAGE]
        printable_address.dps = paf_address[DPS]

        printable_address.as_json.compact
      end
    end
  end
end
