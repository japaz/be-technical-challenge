#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'checkout'

class CheckoutCLI
  def initialize(checkout)
    @checkout = checkout
  end

  def run
    puts 'Enter items as: product_code,name,price (e.g. 3.11) (empty line to finish)'
    loop do
      print '> '
      input = gets.strip
      break if input.empty?
      begin
        product_code, name, price_cents = parse_input(input)
        @checkout.add_item(product_code: product_code, name: name, price: price_cents)
        puts "Current total: #{format_euro(@checkout.total)}"
      rescue ArgumentError => e
        puts "Error: #{e.message}"
      end
    end
    puts "Final total: #{format_euro(@checkout.total)}"
  end

  def parse_input(input)
    parts = input.split(',')
    raise ArgumentError, 'Input must have 3 comma-separated values' unless parts.size == 3
    product_code = parts[0].strip
    name = parts[1].strip
    price_cents = parse_euro_to_cents(parts[2].strip)
    [product_code, name, price_cents]
  end

  def parse_euro_to_cents(price_str)
    begin
      price = Float(price_str)
      raise ArgumentError, 'Price must be non-negative' if price < 0
      (price * 100).round
    rescue ArgumentError, TypeError
      raise ArgumentError, 'Invalid price format'
    end
  end

  def format_euro(cents)
    sprintf('%.2f €', cents.to_f / 100)
  end
end

if $PROGRAM_NAME == __FILE__
  checkout = Checkout.new(rules: [
    PricingRules::BuyOneGetOneFreeRule.new,
    PricingRules::DiscountForStrawberriesRule.new,
    PricingRules::DiscountForCoffeeRule.new
  ]) # Add pricing rules as needed
  cli = CheckoutCLI.new(checkout)
  cli.run
end
