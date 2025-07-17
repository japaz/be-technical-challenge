# frozen_string_literal: true

require_relative 'pricing_rule'

module PricingRules
  # Implements a discount for bulk purchases of a specific product.
  # The discount can be a new fixed price per item or a percentage multiplier.
  class BulkDiscountRule < PricingRules::PricingRule
    def initialize(product_code:, min_quantity:, new_price_cents: nil, discount_multiplier: nil)
      @product_code = product_code
      @min_quantity = min_quantity
      @new_price_cents = new_price_cents
      @discount_multiplier = discount_multiplier

      validate_arguments
    end

    def calculate_discount(cart:, catalog:)
      product_count = cart.items.count { |code| code == @product_code }
      return 0 unless product_count >= @min_quantity

      product = catalog.find(@product_code)
      original_price_for_items = product.price_cents * product_count

      discounted_price = if @new_price_cents
                           @new_price_cents * product_count
                         else # @discount_multiplier must be present due to validation
                           (original_price_for_items * @discount_multiplier).round
                         end

      original_price_for_items - discounted_price
    end

    private

    def validate_arguments
      return if @new_price_cents || @discount_multiplier

      raise ArgumentError, 'Either new_price_cents or discount_multiplier must be provided.'
    end
  end
end