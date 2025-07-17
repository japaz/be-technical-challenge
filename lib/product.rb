# frozen_string_literal: true

# The Product class represents a purchasable item in the catalog.
# It stores the product code, name, and price in cents.
Product = Struct.new(:code, :name, :price_cents, keyword_init: true)