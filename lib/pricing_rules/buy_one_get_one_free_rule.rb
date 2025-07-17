# frozen_string_literal: true

require_relative "./pricing_rule"

module PricingRules
  class BuyOneGetOneFreeRule < PricingRule
    def initialize(product_code:)
      @product_code = product_code
    end

    def apply(checkout:, total:)
      product_count = checkout.items.count { |item| item == @product_code }
      product_price = checkout.product_catalog.find(@product_code).price_cents
      if product_count > 1
        total -= (product_count / 2) * product_price
      end
      total
    end
  end
end