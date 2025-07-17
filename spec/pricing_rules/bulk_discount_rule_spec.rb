# frozen_string_literal: true

require_relative '../../lib/pricing_rules/bulk_discount_rule'
require_relative '../../lib/cart'
require_relative '../../lib/product_catalog'

describe PricingRules::BulkDiscountRule do
  let(:catalog) { ProductCatalog.new }
  let(:cart) { Cart.new }

  context 'Bulk discount with new price' do
    it 'calculates the correct discount when quantity threshold is met' do
      rule = described_class.new(product_code: 'GR1', min_quantity: 3, new_price_cents: 200)
      3.times { cart.add_item('GR1') }

      original_price = 3 * catalog.find('GR1').price_cents # 933
      discounted_price = 3 * 200 # 600
      expected_discount = original_price - discounted_price # 333

      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(expected_discount)
    end

    it 'returns zero discount if quantity is below threshold' do
      2.times { cart.add_item('GR1') }
      rule = described_class.new(product_code: 'GR1', min_quantity: 4, new_price_cents: 200)
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(0)
    end
  end

  context 'Bulk discount with discount multiplier' do
    it 'calculates the correct discount if quantity threshold is met' do
      rule = described_class.new(product_code: 'CF1', min_quantity: 3, discount_multiplier: (2.0 / 3.0))
      3.times { cart.add_item('CF1') }
      original_price = 3 * catalog.find('CF1').price_cents # 3369
      discounted_price = (original_price * (2.0 / 3.0)).round # 2246
      expected_discount = original_price - discounted_price # 1123
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(expected_discount)
    end

    it 'returns zero discount if quantity is below threshold' do
      rule = described_class.new(product_code: 'CF1', min_quantity: 4, discount_multiplier: (2.0 / 3.0))
      3.times { cart.add_item('CF1') }
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(0)
    end
  end

  context 'No discount if product not present' do
    it 'returns zero discount if the relevant product is not in the cart' do
      rule = described_class.new(product_code: 'CF1', min_quantity: 1, new_price_cents: 900)
      cart.add_item('GR1')
      cart.add_item('SR1')
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(0)
    end
  end

  context 'Initialization' do
    it 'raises an error if neither new price nor multiplier is provided' do
      expect do
        described_class.new(product_code: 'GR1', min_quantity: 3)
      end.to raise_error(ArgumentError, 'Either new_price_cents or discount_multiplier must be provided.')
    end
  end
end
