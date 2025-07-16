# frozen_string_literal: true
require_relative "pricing_rules/buy_one_get_one_free_rule"
require_relative "pricing_rules/discount_for_strawberries_rule"
require_relative "pricing_rules/discount_for_coffee_rule"

class Checkout
  def initialize(rules: [])
    @rules = rules
  end

  def total
    total = items.sum(&:price)
    @rules.each do |rule|
      total = rule.apply(items: items, total: total)
    end
    total
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