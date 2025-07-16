# frozen_string_literal: true

require_relative "./pricing_rule"

module PricingRules
  class BuyOneGetOneFreeRule < PricingRule
    def apply(checkout:, total:)
      green_tea_count = checkout.items.count { |item| item == "GR1" }
      green_tea_price = checkout.product_catalog.find("GR1").price_cents
      if green_tea_count > 1
        total -= (green_tea_count / 2) * green_tea_price
      end
      total
    end
  end
end