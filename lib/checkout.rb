# frozen_string_literal: true

require_relative "pricing_rules/buy_one_get_one_free_rule"
require_relative "pricing_rules/discount_for_strawberries_rule"
require_relative "pricing_rules/discount_for_coffee_rule"
require_relative "product_catalog"

class Checkout
  attr_reader :product_catalog

  def initialize(rules: [], product_catalog: ProductCatalog.new)
    @rules = rules
    @product_catalog = product_catalog
  end

  def total
    total = items.map{|product_code| @product_catalog.find(product_code)}.sum(&:price_cents)
    @rules.each do |rule|
      total = rule.apply(checkout: self, total:)
    end
    total
  end

  def add_item(product_code)
    raise ArgumentError, "Product code cannot be nil" if product_code.nil?
    raise ArgumentError, "Product code cannot be empty" if product_code.empty?
    raise ArgumentError, "Product does not exist" unless @product_catalog.find(product_code)
    items << product_code
  end

  def items
    @items ||= []
  end
end