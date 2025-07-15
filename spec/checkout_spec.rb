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
end