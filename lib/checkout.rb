# frozen_string_literal: true

class Checkout
  def total
    total = items.sum(&:price)
    apply_buy_one_get_one_free_discount_for_green_tea(total)
  end

  def add_item(product_code:, name:, price:)
    items << Item.new(product_code: product_code, name: name, price: price)
  end

  class Item
    attr_reader :product_code, :name, :price

    def initialize(product_code:, name:, price:)
      @product_code = product_code
      @name = name
      @price = price
    end
  end

  private

  def apply_buy_one_get_one_free_discount_for_green_tea(total)
    green_tea_count = items.count { |item| item.product_code == "GR1" }
    if green_tea_count > 1
      total -= (green_tea_count / 2) * items.find { |item| item.product_code == "GR1" }.price
    end
    total
  end

  def items
    @items ||= []
  end
end