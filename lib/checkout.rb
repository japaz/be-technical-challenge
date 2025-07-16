# frozen_string_literal: true
require_relative "pricing_rules/buy_one_get_one_free_rule"
require_relative "pricing_rules/discount_for_strawberries_rule"
require_relative "pricing_rules/discount_for_coffee_rule"

class Checkout
  def total
    total = items.sum(&:price)
    total = PricingRules::BuyOneGetOneFreeRule.new.apply(items:, total:)
    total = PricingRules::DiscountForStrawberriesRule.new.apply(items:, total:)
    PricingRules::DiscountForCoffeeRule.new.apply(items:, total:)
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
  def items
    @items ||= []
  end
end