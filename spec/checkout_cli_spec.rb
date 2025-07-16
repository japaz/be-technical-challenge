# frozen_string_literal: true

require 'rspec'
require_relative '../lib/checkout_cli'
require_relative '../lib/checkout'

class DummyRule
  def apply(items:, total:)
    total
  end
end

describe CheckoutCLI do
  let(:checkout) { Checkout.new(rules: [DummyRule.new]) }
  let(:cli) { CheckoutCLI.new(checkout) }

  describe '#parse_input' do
    it 'parses valid input' do
      expect(cli.parse_input('P001,Coffee,2.5')).to eq(['P001', 'Coffee', 250])
    end

    it 'raises error for missing fields' do
      expect { cli.parse_input('P001,Coffee') }.to raise_error(ArgumentError)
    end

    it 'raises error for invalid price' do
      expect { cli.parse_input('P001,Coffee,abc') }.to raise_error(ArgumentError)
    end
  end

  describe '#run' do
    it 'adds items and computes total (integration test)' do
      allow(cli).to receive(:gets).and_return('P001,Coffee,2.5', 'P002,Tea,1.5', '')
      expect { cli.run }.to output(/Current total: 2.5.*Current total: 4.0.*Final total: 4.0/m).to_stdout
    end

    it 'handles invalid input gracefully' do
      allow(cli).to receive(:gets).and_return('badinput', 'P001,Coffee,2.5', '')
      expect { cli.run }.to output(/Error:.*Current total: 2.5.*Final total: 2.5/m).to_stdout
    end
  end

  describe '#parse_euro_to_cents' do
    it 'converts valid euro string to cents' do
      expect(cli.parse_euro_to_cents('3.11')).to eq(311)
      expect(cli.parse_euro_to_cents('0.99')).to eq(99)
      expect(cli.parse_euro_to_cents('10.00')).to eq(1000)
      expect(cli.parse_euro_to_cents('3.1')).to eq(310)
    end

    it 'raises error for invalid format' do
      expect { cli.parse_euro_to_cents('3,11') }.to raise_error(ArgumentError)
      expect { cli.parse_euro_to_cents('abc') }.to raise_error(ArgumentError)
      expect { cli.parse_euro_to_cents('') }.to raise_error(ArgumentError)
      expect { cli.parse_euro_to_cents('-1.00') }.to raise_error(ArgumentError)
    end
  end
end
