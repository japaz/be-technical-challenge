# frozen_string_literal: true

require_relative '../../lib/pricing_rules/buy_one_get_one_free_rule'
require_relative '../../lib/cart'
require_relative '../../lib/product_catalog'

describe PricingRules::BuyOneGetOneFreeRule do
  let(:catalog) { ProductCatalog.new }
  let(:cart) { Cart.new }
  let(:rule) { described_class.new(product_code: 'GR1') }
  let(:product_price) { catalog.find('GR1').price_cents }

  context 'when the relevant product is in the cart' do
    it 'returns zero discount for a single item' do
      cart.add_item('GR1')
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(0)
    end

    it 'calculates a discount equal to one item price for two items' do
      2.times { cart.add_item('GR1') }
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(product_price)
    end

    it 'calculates a discount equal to one item price for three items' do
      3.times { cart.add_item('GR1') }
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(product_price)
    end

    it 'calculates a discount equal to two item prices for four items' do
      4.times { cart.add_item('GR1') }
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(product_price * 2)
    end

    it 'does not apply discount to other items in the cart' do
      2.times { cart.add_item('GR1') }
      cart.add_item('SR1')
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(product_price)
    end
  end

  context 'when the relevant product is not in the cart' do
    it 'returns zero discount for an empty cart' do
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(0)
    end

    it 'returns zero discount if only other products are present' do
      cart.add_item('SR1')
      cart.add_item('CF1')
      expect(rule.calculate_discount(cart: cart, catalog: catalog)).to eq(0)
    end
  end
end