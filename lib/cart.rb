# frozen_string_literal: true

# The Cart class represents the collection of items a customer intends to purchase.
# It manages the state of the items in the basket and provides methods to add items.
class Cart
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(product_code)
    raise ArgumentError, 'Product code cannot be nil or empty' if product_code.nil? || product_code.empty?

    @items << product_code
  end
end
