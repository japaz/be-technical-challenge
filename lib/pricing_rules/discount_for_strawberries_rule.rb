# frozen_string_literal: true

require_relative './pricing_rule'

module PricingRules
  class DiscountForStrawberriesRule < PricingRule
    def apply(items:, total:)
      strawberries_count = items.count { |item| item.product_code == "SR1" }
      strawberries_count >= 3 ? total - strawberries_count * 50 : total
    end
  end
end
