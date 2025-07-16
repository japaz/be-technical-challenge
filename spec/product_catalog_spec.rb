require_relative '../lib/product_catalog'

describe ProductCatalog do
  let(:catalog) { ProductCatalog.new }

  describe '#find' do
    it 'returns the correct product for a valid code' do
      product = catalog.find('GR1')
      expect(product).not_to be_nil
      expect(product.code).to eq('GR1')
      expect(product.name).to eq('Green Tea')
      expect(product.price_cents).to eq(311)
    end

    it 'returns nil for an unknown product code' do
      expect(catalog.find('UNKNOWN')).to be_nil
    end
  end
end

