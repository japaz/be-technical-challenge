# frozen_string_literal: true

require "rspec"
require_relative "../lib/checkout"
require_relative '../lib/pricing_rules/buy_one_get_one_free_rule'
require_relative '../lib/pricing_rules/bulk_discount_rule'

RSpec.describe Checkout do
  subject do
    described_class.new(rules: [
      PricingRules::BuyOneGetOneFreeRule.new("GR1"),
      PricingRules::BulkDiscountRule.new(product_code: 'SR1', min_quantity: 3, new_price_cents: 450),
      PricingRules::BulkDiscountRule.new(product_code: 'CF1', min_quantity: 3, discount_multiplier: 2.0 / 3.0)
    ])
  end

  it "has a total of 0 for an empty basket" do
    expect(subject.total).to eq(0)
  end

  it "returns the correct total for a basket with one item" do
    subject.add_item("GR1")
    expect(subject.total).to eq(311)
  end

  context "when there is more than one green tea in the basket" do
    it "returns the correct total for a basket with multiple items" do
      subject.add_item("GR1")
      subject.add_item("SR1")
      subject.add_item("CF1")
      expect(subject.total).to eq(1934)
    end

    it "returns just the price for one green tea if there are two in the basket" do
      subject.add_item("GR1")
      subject.add_item("GR1")
      expect(subject.total).to eq(311)
    end

    it "returns the price for two green teas if there are three in the basket" do
      subject.add_item("GR1")
      subject.add_item("GR1")
      subject.add_item("GR1")
      expect(subject.total).to eq(622)
    end

    it "returns the price for two geen teas if there are four in the basket" do
      subject.add_item("GR1")
      subject.add_item("GR1")
      subject.add_item("GR1")
      subject.add_item("GR1")
      expect(subject.total).to eq(622)
    end

    it "returns the correct total for a basket with multiple items including green tea" do
      subject.add_item("GR1")
      subject.add_item("SR1")
      subject.add_item("CF1")
      subject.add_item("GR1")
      expect(subject.total).to eq(1934)
    end
  end

  context "when there are 3 or more strawberries in the basket" do
    it "returns the reduced price for strawberries" do
      subject.add_item("SR1")
      subject.add_item("SR1")
      subject.add_item("SR1")
      expect(subject.total).to eq(1350)
    end

    it "returns the reduced price for strawberries when there are more than 3" do
      subject.add_item("SR1")
      subject.add_item("SR1")
      subject.add_item("SR1")
      subject.add_item("SR1")
      expect(subject.total).to eq(1800)
    end

    it "returns the reduced price for strawberries when there more than 3 and green tea" do
      subject.add_item("SR1")
      subject.add_item("SR1")
      subject.add_item("SR1")
      subject.add_item("GR1")
      expect(subject.total).to eq(1661)
    end
  end

  context "when there are more than 3 coffee in the basket" do
    it "returns the reduced price for coffee when there are 3" do
      subject.add_item("CF1")
      subject.add_item("CF1")
      subject.add_item("CF1")
      expect(subject.total).to eq(2246)
    end

    it "returns the reduced price for coffee when there are more than 3" do
      subject.add_item("CF1")
      subject.add_item("CF1")
      subject.add_item("CF1")
      subject.add_item("CF1")
      expect(subject.total).to eq(2995)
    end

    it "returns the reduced price for coffee when there are more than 3 and strawberries" do
      subject.add_item("CF1")
      subject.add_item("CF1")
      subject.add_item("CF1")
      subject.add_item("SR1")
      expect(subject.total).to eq(2746)
    end
  end
end