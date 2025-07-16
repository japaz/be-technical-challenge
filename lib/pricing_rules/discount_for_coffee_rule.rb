# frozen_string_literal: true

require_relative "./pricing_rule"

module PricingRules
  class DiscountForCoffeeRule < PricingRule
    def apply(items:, total:)
      coffee_count = items.count { |item| item.product_code == "CF1" }
      if coffee_count >= 3
        total_coffee_price = items.select { |item| item.product_code == "CF1" }.sum(&:price)
        total = total - total_coffee_price + (total_coffee_price * 2 / 3.0).round(0)
      end
      total
    end
  end
end