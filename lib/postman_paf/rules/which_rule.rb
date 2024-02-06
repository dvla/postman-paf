# frozen_string_literal: true

module PostmanPAF
  module Rules
    module WhichRule
      RULE_02 = %w[buildingNumber].freeze
      RULE_03 = %w[buildingName].freeze
      RULE_04 = %w[buildingName buildingNumber].freeze
      RULE_05 = %w[buildingNumber subBuildingName].freeze
      RULE_06 = %w[buildingName subBuildingName].freeze
      RULE_07 = %w[buildingName buildingNumber subBuildingName].freeze

      # Matches address elements found in PAF address to criteria for
      #   applicable Royal Mail rule. Rule 1 is defaulted to if
      #   subBuildingName, buildingName and buildingNumber are NOT
      #   present.
      # @param premise_elements [Array<String>] the premise elements
      #   found in the PAF address.
      # @return [Symbol] the applicable Royal Mail conversion rule.
      def self.rule_to_apply(premise_elements:)
        case premise_elements.sort
        when RULE_02
          :rule2
        when RULE_03
          :rule3
        when RULE_04
          :rule4
        when RULE_05
          :rule5
        when RULE_06
          :rule6
        when RULE_07
          :rule7
        else
          :rule1
        end
      end
    end
  end
end
