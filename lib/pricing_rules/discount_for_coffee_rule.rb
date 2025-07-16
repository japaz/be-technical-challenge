# frozen_string_literal: true

require_relative "./pricing_rule"

module PricingRules
  class DiscountForCoffeeRule < PricingRule
    def apply(checkout:, total:)
      coffee_count = checkout.items.count { |item| item == "CF1" }
      coffee_price = checkout.product_catalog.find("CF1").price_cents
      if coffee_count >= 3
        total_coffee_price = coffee_count * coffee_price
        total = total - total_coffee_price + (total_coffee_price * 2 / 3.0).round(0)
      end
      total
    end
  end
end