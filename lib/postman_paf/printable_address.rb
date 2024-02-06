# frozen_string_literal: true

module PostmanPAF
  # Getter and setter class for variables of the converted address.
  # @attr line1 [String] converted.
  # @attr line2 [String] converted.
  # @attr line3 [String] converted.
  # @attr line4 [String] converted.
  # @attr line5 [String] the postTown of an address. Not converted.
  # @attr country [String] not converted.
  # @attr postcode [String] not converted.
  # @attr language [String] not converted.
  # @attr dps [String] the delivery point suffix, a unique 2-digit
  #   code for each delivery point in a postcode. Not converted.
  class PrintableAddress
    attr_accessor :line1, :line2, :line3, :line4, :line5, :country, :postcode, :language, :dps

    # Converts PrintableAddress object to JSON Hash representation
    #   without ActiveSupport.
    # @return [Hash] converted address data as JSON Hash.
    def as_json
      {
        'line1' => @line1,
        'line2' => @line2,
        'line3' => @line3,
        'line4' => @line4,
        'line5' => @line5,
        'postcode' => @postcode,
        'country' => @country,
        'language' => @language,
        'dps' => @dps
      }
    end
  end
end
