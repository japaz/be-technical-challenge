# frozen_string_literal: true
require_relative "pricing_rules/buy_one_get_one_free_rule"
require_relative "pricing_rules/discount_for_strawberries_rule"

class Checkout
  def total
    total = items.sum(&:price)
    total = PricingRules::BuyOneGetOneFreeRule.new.apply(items:, total:)
    total = PricingRules::DiscountForStrawberriesRule.new.apply(items:, total:)
    apply_discount_for_coffees(total)
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

  def apply_discount_for_coffees(total)
    coffee_count = items.count { |item| item.product_code == "CF1" }
    if coffee_count >= 3
      total_coffee_price = items.select { |item| item.product_code == "CF1" }.sum(&:price)
      total = total - total_coffee_price + (total_coffee_price * 2 / 3.0).round(0)
    end
    total
  end

  def items
    @items ||= []
  end
end