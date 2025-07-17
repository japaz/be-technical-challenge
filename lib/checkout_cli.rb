#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'checkout'

class CheckoutCLI
  def initialize(checkout)
    @checkout = checkout
  end

  def run
    puts 'Scan items by entering their codes (e.g., "GR1", "SR1", "CF1").'
    puts 'Enter one item code per line.'
    puts 'Press Enter without input to finish and see the total.'
    loop do
      print '> '
      input = gets.strip
      break if input.empty?
      begin
        @checkout.add_item(input)
        puts "Current total: #{format_euro(@checkout.total)}"
      rescue ArgumentError => e
        puts "Error: #{e.message}"
      end
    end
    puts "Final total: #{format_euro(@checkout.total)}"
  end

  def format_euro(cents)
    sprintf('%.2f €', cents.to_f / 100)
  end
end

if $PROGRAM_NAME == __FILE__
  checkout = Checkout.new(rules: [
    PricingRules::BuyOneGetOneFreeRule.new(product_code: 'GR1'),
    PricingRules::BulkDiscountRule.new(product_code: 'SR1', min_quantity: 3, new_price_cents: 450),
    PricingRules::BulkDiscountRule.new(product_code: 'CF1', min_quantity: 3, discount_multiplier: 2.0 / 3.0)
  ]) # Add pricing rules as needed
  cli = CheckoutCLI.new(checkout)
  cli.run
end
