# frozen_string_literal: true

module PostmanPAF
  module Exceptions
    # Only buildingName and subBuildingName values determine if an exception
    #   applies.
    BUILDING_NAME = 'buildingName'
    SUB_BUILDING_NAME = 'subBuildingName'

    # Determines exception(s) to be applied to PAF address during conversion
    #   if specific criteria are met - exceptions can only apply to Rule 3,
    #   Rule 5, Rule 6 and Rule 7 PAF addresses.
    # @param rule [Symbol] the conversion rule to be applied.
    # @param paf_address [Hash] to be converted.
    # @return [Symbol, Array<Symbol>] the exception(s) to be applied.
    def self.which_exception(rule:, paf_address:)
      case rule
      when :rule3
        PostmanPAF::Exceptions::WhichException.exception_to_apply_rule3(paf_address: paf_address)
      when :rule5, :rule7
        PostmanPAF::Exceptions::WhichException.exception_to_apply_rule5_rule7(paf_address: paf_address)
      when :rule6
        PostmanPAF::Exceptions::WhichException.exception_to_apply_rule6(paf_address: paf_address)
      else
        :exceptions_not_applicable
      end
    end
  end
end
