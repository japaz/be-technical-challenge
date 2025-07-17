# frozen_string_literal: true

require_relative "product_catalog"
require_relative "cart"

# The Checkout class is responsible for calculating the final price of a cart
# by applying a set of pricing rules. It is stateless regarding the items themselves.
class Checkout
  attr_reader :product_catalog, :rules

  def initialize(rules: [], product_catalog: ProductCatalog.new)
    @rules = rules
    @product_catalog = product_catalog
  end

  # Calculates the final total for a given cart.
  # @param cart [Cart] The cart object containing the items to be priced.
  # @return [Integer] The final total in cents.
  def total(cart)
    raise ArgumentError, 'A Cart object is required' unless cart.is_a?(Cart)

    base_total = cart.items.sum { |code| @product_catalog.find(code)&.price_cents || 0 }

    total_discount = @rules.sum do |rule|
      rule.calculate_discount(cart: cart, catalog: @product_catalog)
    end

    base_total - total_discount
  end
end