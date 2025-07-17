# frozen_string_literal: true

require_relative "../../lib/pricing_rules/buy_one_get_one_free_rule"
require_relative "../../lib/checkout"
require_relative "../../lib/product_catalog"
require_relative "../../lib/product"

describe PricingRules::BuyOneGetOneFreeRule do
  let(:product_code) { "GR1" }
  let(:green_tea) { Product.new(code: product_code, name: "Green Tea", price_cents: 100) }
  let(:product_catalog) { ProductCatalog.new }
  let(:rule) { described_class.new(product_code: product_code) }

  let(:checkout) do
    double(
      :checkout,
      items: items,
      product_catalog: product_catalog
    )
  end

  context "when there is only one item" do
    let(:items) { [product_code] }
    it "does not apply any discount" do
      expect(rule.apply(checkout: checkout, total: 311)).to eq(311)
    end
  end

  context "when there are two items" do
    let(:items) { [product_code, product_code] }
    it "applies one free item discount" do
      expect(rule.apply(checkout: checkout, total: 622)).to eq(311)
    end
  end

  context "when there are three items" do
    let(:items) { [product_code, product_code, product_code] }
    it "applies one free item discount" do
      expect(rule.apply(checkout: checkout, total: 933)).to eq(622)
    end
  end

  context "when there are four items" do
    let(:items) { [product_code, product_code, product_code, product_code] }
    it "applies two free item discounts" do
      expect(rule.apply(checkout: checkout, total: 1244)).to eq(622)
    end
  end
end
