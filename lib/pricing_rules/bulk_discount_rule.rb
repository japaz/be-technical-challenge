# frozen_string_literal: true

module PricingRules
  class BulkDiscountRule < PricingRules::PricingRule
    def initialize(product_code:, min_quantity:, new_price_cents: nil, discount_multiplier: nil)
      @product_code = product_code
      @min_quantity = min_quantity
      @new_price_cents = new_price_cents
      @discount_multiplier = discount_multiplier
    end

    def apply(checkout:, total:)
      product_count = checkout.items.count { |item| item == @product_code }
      if product_count > 0 && product_count >= @min_quantity
        product_price = checkout.product_catalog.find(@product_code).price_cents
        total_product_price = product_count * product_price
        unless @new_price_cents.nil?
          total = total - total_product_price + (@new_price_cents * product_count)
        end
        unless @discount_multiplier.nil?
          total = total - total_product_price + (total_product_price * @discount_multiplier).round(0)
        end
      end
      total
    end
  end
end