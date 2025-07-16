# frozen_string_literal: true

require_relative "./pricing_rule"

module PricingRules
  class BuyOneGetOneFreeRule < PricingRule
    def apply(items:, total:)
      green_tea_count = items.count { |item| item.product_code == "GR1" }
      if green_tea_count > 1
        total -= (green_tea_count / 2) * items.find { |item| item.product_code == "GR1" }.price
      end
      total
    end
  end
end