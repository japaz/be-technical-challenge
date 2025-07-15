require_relative "../lib/checkout"

RSpec.describe Checkout do
  subject { described_class.new }

  it "has a total of 0 for an empty basket" do
    expect(subject.total).to eq(0)
  end
end