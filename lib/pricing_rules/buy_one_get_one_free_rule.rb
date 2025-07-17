# frozen_string_literal: true

require_relative 'pricing_rule'

module PricingRules
  class BuyOneGetOneFreeRule < PricingRule
    def initialize(product_code:)
      @product_code = product_code
    end

    def calculate_discount(cart:, catalog:)
      product_count = cart.items.count { |item| item == @product_code }
      return 0 if product_count < 2

      product_price = catalog.find(@product_code).price_cents
      (product_count / 2) * product_price
    end
  end
end