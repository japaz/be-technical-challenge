# frozen_string_literal: true
require_relative 'product'

# The ProductCatalog class provides an in-memory catalog of available products.
# It allows lookup of products by their code and is used for pricing and validation.
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