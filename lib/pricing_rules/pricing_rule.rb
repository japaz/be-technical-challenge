# frozen_string_literal: true

module PricingRules
  class PricingRule
    # Calculates the total discount amount for a given cart.
    # @param cart [Cart] The cart to be evaluated.
    # @param catalog [ProductCatalog] The catalog to find the product price.
    # @return [Integer] The total discount in cents.
    def calculate_discount(cart:, catalog:)
      raise NotImplementedError, "Subclasses must implement the calculate_discount method"
    end
  end
end
