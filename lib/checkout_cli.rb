#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'checkout'
require_relative 'cart'
require_relative 'product_catalog'

require_relative 'pricing_rules/buy_one_get_one_free_rule'
require_relative 'pricing_rules/bulk_discount_rule'

class CheckoutCLI
  def initialize(checkout, cart, product_catalog)
    @checkout = checkout
    @cart = cart
    @product_catalog = product_catalog
  end

  def run
    puts 'Scan items by entering their codes (e.g., "GR1", "SR1", "CF1").'
    puts 'Enter one item code per line.'
    puts 'Press Enter without input to finish and see the total.'

    loop do
      print '> '
      input = gets.strip.upcase
      break if input.empty?

      begin
        # Validate product existence before adding to cart
        raise ArgumentError, "Product code '#{input}' not found." unless @product_catalog.find(input)

        @cart.add_item(input)
        current_total = @checkout.total(@cart)
        puts "Item added. Current total: #{format_euro(current_total)}"
      rescue ArgumentError => e
        puts "Error: #{e.message}"
      end
    end

    final_total = @checkout.total(@cart)
    puts "\nFinal basket: #{@cart.items.join(', ')}"
    puts "Final total: #{format_euro(final_total)}"
  end

  private

  def format_euro(cents)
    sprintf('%.2f €', cents.to_f / 100)
  end
end

if $PROGRAM_NAME == __FILE__
  # 1. Set up the infrastructure: catalog and pricing rules.
  # This configuration is the "brain" of the checkout system.
  product_catalog = ProductCatalog.new
  rules = [
    PricingRules::BuyOneGetOneFreeRule.new(product_code: 'GR1'),
    PricingRules::BulkDiscountRule.new(product_code: 'SR1', min_quantity: 3, new_price_cents: 450),
    PricingRules::BulkDiscountRule.new(product_code: 'CF1', min_quantity: 3, discount_multiplier: 2.0 / 3.0)
  ]

  # 2. Instantiate the core components, injecting the dependencies.
  cart = Cart.new
  checkout = Checkout.new(rules: rules, product_catalog: product_catalog)

  # 3. Run the command-line interface.
  cli = CheckoutCLI.new(checkout, cart, product_catalog)
  cli.run
end
