# frozen_string_literal: true

class Checkout
  def total
    total = items.sum(&:price)
    total = apply_buy_one_get_one_free_discount_for_green_tea(total)
    apply_discount_for_strawberries(total)
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

  def apply_discount_for_strawberries(total)
    strawberries_count = items.count { |item| item.product_code == "SR1" }
    strawberries_count >= 3 ? total - strawberries_count * 50 : total
  end

  def items
    @items ||= []
  end
end