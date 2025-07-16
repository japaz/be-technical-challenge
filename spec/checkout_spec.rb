# frozen_string_literal: true

require "rspec"
require_relative "../lib/checkout"

RSpec.describe Checkout do
  subject { described_class.new }

  it "has a total of 0 for an empty basket" do
    expect(subject.total).to eq(0)
  end

  it "returns the correct total for a basket with one item" do
    subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
    expect(subject.total).to eq(311)
  end

  context "when there is more than one green tea in the basket" do
    it "returns the correct total for a basket with multiple items" do
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "CF1", name: "Coffe", price: 1123)
      expect(subject.total).to eq(1934)
    end

    it "returns just the price for one green tea if there are two in the basket" do
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      expect(subject.total).to eq(311)
    end

    it "returns the price for two green teas if there are three in the basket" do
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      expect(subject.total).to eq(622)
    end

    it "returns the price for two geen teas if there are four in the basket" do
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      expect(subject.total).to eq(622)
    end

    it "returns the correct total for a basket with multiple items including green tea" do
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "CF1", name: "Coffe", price: 1123)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      expect(subject.total).to eq(1934)
    end
  end

  context "when there are 3 or more strawberries in the basket" do
    it "returns the reduced price for strawberries" do
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      expect(subject.total).to eq(1350)
    end

    it "returns the reduced price for strawberries when there are more than 3" do
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      expect(subject.total).to eq(1800)
    end

    it "returns the reduced price for strawberries when there more than 3 and green tea" do
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "SR1", name: "Strawberries", price: 500)
      subject.add_item(product_code: "GR1", name: "Green Tea", price: 311)
      expect(subject.total).to eq(1661)
    end
  end
end