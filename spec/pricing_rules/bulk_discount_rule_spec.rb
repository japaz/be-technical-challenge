# frozen_string_literal: true

require_relative '../../lib/pricing_rules/bulk_discount_rule'
require_relative '../../lib/product_catalog'
require_relative '../../lib/checkout'
require_relative '../../lib/product'

describe PricingRules::BulkDiscountRule do
  let(:catalog) { ProductCatalog.new }
  let(:checkout) { double('Checkout', items: items, product_catalog: catalog) }

  context 'Bulk discount with new price' do
    let(:items) { %w[GR1 GR1 GR1] }
    it 'applies new price when quantity threshold is met' do
      rule = described_class.new(product_code: 'GR1', min_quantity: 3, new_price_cents: 200)
      total = 3 * catalog.find('GR1').price_cents
      expect(rule.apply(checkout: checkout, total: total)).to eq(600)
    end

    it 'does not apply discount if quantity is below threshold' do
      rule = described_class.new(product_code: 'GR1', min_quantity: 4, new_price_cents: 200)
      total = 4 * catalog.find('GR1').price_cents
      expect(rule.apply(checkout: checkout, total: total)).to eq(total)
    end
  end

  context 'Bulk discount with discount multiplier' do
    let(:items) { %w[CF1 CF1 CF1] }
    it 'it applies discount if quantity threshold is met' do
      rule = described_class.new(product_code: 'CF1', min_quantity: 3, discount_multiplier: (2.0/3.0))
      total = 3 * catalog.find('CF1').price_cents
      expect(rule.apply(checkout: checkout, total: total)).to eq(2246)
    end

    it 'it correctly rounds the total' do
      rule = described_class.new(product_code: 'CF1', min_quantity: 3, discount_multiplier: (2.5/3.0))
      total = 3 * catalog.find('CF1').price_cents
      expect(rule.apply(checkout: checkout, total: total)).to eq(2808)
    end

    it 'does not apply discount if quantity is below threshold' do
      rule = described_class.new(product_code: 'CF1', min_quantity: 4, discount_multiplier: (2.0/3.0))
      total = 2 * catalog.find('CF1').price_cents
      expect(rule.apply(checkout: checkout, total: total)).to eq(total)
    end
  end

  context 'No discount if product not present' do
    let(:items) { %w[GR1 SR1] }
    it 'does not apply discount if product is not present' do
      rule = described_class.new(product_code: 'CF1', min_quantity: 0, new_price_cents: 900, discount_multiplier: nil)
      total = catalog.find('GR1').price_cents + catalog.find('SR1').price_cents
      expect(rule.apply(checkout: checkout, total: total)).to eq(total)
    end
  end

  context 'No new_price_cents nor discount_multiplier' do
    let(:items) { %w[GR1 GR1 GR1] }
    it 'does not apply any discount if both are nil' do
      rule = described_class.new(product_code: 'GR1', min_quantity: 3, new_price_cents: nil, discount_multiplier: nil)
      total = 3 * catalog.find('GR1').price_cents
      expect(rule.apply(checkout: checkout, total: total)).to eq(total)
    end
  end
end

