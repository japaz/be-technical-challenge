# frozen_string_literal: true
require_relative 'product'

# In memory product catalog for the sake of simplicity.
class ProductCatalog
  PRODUCTS = {
    'GR1' => Product.new(code: 'GR1', name: 'Green Tea', price_cents: 311),
    'SR1' => Product.new(code: 'SR1', name: 'Strawberries', price_cents: 500),
    'CF1' => Product.new(code: 'CF1', name: 'Coffee', price_cents: 1123)
  }.freeze

  def find(product_code)
    PRODUCTS[product_code]
  end
end