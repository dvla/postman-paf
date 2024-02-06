# frozen_string_literal: true

module PostmanPAF
  module Rules
    # PAF address elements:
    ORGANISATION_NAME = 'organisationName'
    DEPARTMENT_NAME = 'departmentName'
    PO_BOX_NUMBER = 'poBoxNumber'
    BUILDING_NUMBER = 'buildingNumber'
    BUILDING_NAME = 'buildingName'
    SUB_BUILDING_NAME = 'subBuildingName'
    THOROUGHFARE_NAME = 'thoroughfareName'
    DEPENDENT_THOROUGHFARE_NAME = 'dependentThoroughfareName'
    DEPENDENT_LOCALITY = 'dependentLocality'
    DOUBLE_DEPENDENT_LOCALITY = 'doubleDependentLocality'
    POST_TOWN = 'postTown'
    POSTCODE = 'postcode'
    COUNTRY = 'country'
    LANGUAGE = 'language'
    DPS = 'dps'
    # Only the presence of subBuildingName, buildingName and
    #   buildingNumber determine which Rule applies.
    ADDRESS_ELEMENTS_FOR_RULE = %w[subBuildingName buildingName buildingNumber].freeze

    # Identifies address elements found in PAF address and returns
    #   applicable rule.
    # @param paf_address [Hash] to be converted.
    # @return [Symbol] the conversion rule to apply to the address
    #   based on address elements found.
    def self.which_rule(paf_address:)
      found_premise_elements = []

      paf_address.each do |key, value|
        # to_s is used to handle an Integer value in the PAF address.
        found_premise_elements << key if ADDRESS_ELEMENTS_FOR_RULE.include?(key) && !value.to_s.empty?
      end

      PostmanPAF::Rules::WhichRule.rule_to_apply(premise_elements: found_premise_elements)
    end

    # Applies the applicable rule and exception (if applicable) to
    #   create the converted printable address data. Rule 1
    #   applies for a PAF address containing an organisationName,
    #   but also applies when defaulting to Rule 1 for a PAF address
    #   that does not contain: organisationName, subBuildingName,
    #   buildingName or buildingNumber.
    # @param rule [Symbol] the conversion rule to be applied to the
    #   address.
    # @param paf_address [Hash] to be converted.
    # @param exception [Symbol] applied during conversion.
    # @return [Array] converted address data.
    def self.apply_rule(rule:, paf_address:, exception:)
      case rule
      when :rule2
        PostmanPAF::Rules::ApplyRule.apply_rule2(paf_address: paf_address)
      when :rule3
        PostmanPAF::Rules::ApplyRule.apply_rule3(paf_address: paf_address, exception: exception)
      when :rule4
        PostmanPAF::Rules::ApplyRule.apply_rule4(paf_address: paf_address)
      when :rule5
        PostmanPAF::Rules::ApplyRule.apply_rule5(paf_address: paf_address, exception: exception)
      when :rule6
        PostmanPAF::Rules::ApplyRule.apply_rule6(paf_address: paf_address, exceptions: exception)
      when :rule7
        PostmanPAF::Rules::ApplyRule.apply_rule7(paf_address: paf_address, exception: exception)
      else
        PostmanPAF::Rules::ApplyRule.apply_rule1(paf_address: paf_address)
      end
    end
  end
end
