# frozen_string_literal: true

require "rspec"
require_relative "../lib/checkout"
require_relative "../lib/cart"
require_relative '../lib/pricing_rules/buy_one_get_one_free_rule'
require_relative '../lib/pricing_rules/bulk_discount_rule'

RSpec.describe Checkout do
  subject do
    described_class.new(rules: [
      PricingRules::BuyOneGetOneFreeRule.new(product_code: "GR1"),
      PricingRules::BulkDiscountRule.new(product_code: 'SR1', min_quantity: 3, new_price_cents: 450),
      PricingRules::BulkDiscountRule.new(product_code: 'CF1', min_quantity: 3, discount_multiplier: 2.0 / 3.0)
    ])
  end

  let(:cart) { Cart.new }

  it "has a total of 0 for an empty basket" do
    expect(subject.total(cart)).to eq(0)
  end

  it "returns the correct total for a basket with one item" do
    cart.add_item("GR1")
    expect(subject.total(cart)).to eq(311)
  end

  context "when there is more than one green tea in the basket" do
    it "returns the correct total for a basket with multiple items" do
      %w[GR1 SR1 CF1].each { |code| cart.add_item(code) }
      expect(subject.total(cart)).to eq(1934)
    end

    it "returns just the price for one green tea if there are two in the basket" do
      2.times { cart.add_item("GR1") }
      expect(subject.total(cart)).to eq(311)
    end

    it "returns the price for two green teas if there are three in the basket" do
      3.times { cart.add_item("GR1") }
      expect(subject.total(cart)).to eq(622)
    end

    it "returns the price for two geen teas if there are four in the basket" do
      4.times { cart.add_item("GR1") }
      expect(subject.total(cart)).to eq(622)
    end

    it "returns the correct total for a basket with multiple items including green tea" do
      %w[GR1 SR1 CF1 GR1].each { |code| cart.add_item(code) }
      expect(subject.total(cart)).to eq(1934)
    end
  end

  context "when there are 3 or more strawberries in the basket" do
    it "returns the reduced price for strawberries" do
      3.times { cart.add_item("SR1") }
      expect(subject.total(cart)).to eq(1350)
    end

    it "returns the reduced price for strawberries when there are more than 3" do
      4.times { cart.add_item("SR1") }
      expect(subject.total(cart)).to eq(1800)
    end

    it "returns the reduced price for strawberries when there more than 3 and green tea" do
      3.times { cart.add_item("SR1") }
      cart.add_item("GR1")
      expect(subject.total(cart)).to eq(1661)
    end
  end

  context "when there are more than 3 coffee in the basket" do
    it "returns the reduced price for coffee when there are 3" do
      3.times { cart.add_item("CF1") }
      expect(subject.total(cart)).to eq(2246)
    end

    it "returns the reduced price for coffee when there are more than 3" do
      4.times { cart.add_item("CF1") }
      expect(subject.total(cart)).to eq(2995)
    end

    it "returns the reduced price for coffee when there are more than 3 and strawberries" do
      3.times { cart.add_item("CF1") }
      cart.add_item("SR1")
      expect(subject.total(cart)).to eq(2746)
    end
  end

  context "with test data from the README" do
    it "calculates the total for basket: GR1,GR1" do
      %w[GR1 GR1].each { |code| cart.add_item(code) }
      expect(subject.total(cart)).to eq(311)
    end

    it "calculates the total for the basket: SR1,SR1,GR1,SR1" do
      %w[SR1 SR1 GR1 SR1].each { |code| cart.add_item(code) }
      expect(subject.total(cart)).to eq(1661)
    end

    it "calculates the total for the basket: GR1,CF1,SR1,CF1,CF1" do
      %w[GR1 CF1 SR1 CF1 CF1].each { |code| cart.add_item(code) }
      expect(subject.total(cart)).to eq(3057)
    end
  end
end