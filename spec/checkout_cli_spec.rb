# frozen_string_literal: true

require 'rspec'
require_relative '../lib/checkout_cli'
require_relative '../lib/checkout'

class DummyRule
  def apply(checkout:, total:)
    total
  end
end

describe CheckoutCLI do
  let(:checkout) { Checkout.new(rules: [DummyRule.new]) }
  let(:cli) { CheckoutCLI.new(checkout) }

  describe '#run' do
    it 'adds items and computes total (integration test)' do
      allow(cli).to receive(:gets).and_return('GR1', 'SR1', '')
      expect { cli.run }.to output(/Current total: 3.11.*Current total: 8.11.*Final total: 8.11/m).to_stdout
    end

    it 'handles invalid input gracefully' do
      allow(cli).to receive(:gets).and_return('badinput', 'GR1', '')
      expect { cli.run }.to output(/Error:.*Current total: 3.11.*Final total: 3.11/m).to_stdout
    end
  end
end
