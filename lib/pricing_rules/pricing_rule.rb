# frozen_string_literal: true

module PricingRules
  class PricingRule
    def apply(items:, total_price:)
      raise NotImplementedError, "Subclasses must implement the apply method"
    end
  end
end
