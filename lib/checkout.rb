class Checkout
  def total
    items.sum(&:price)
  end

  def add_item(product_code:, name:, price:)
    items << Item.new(product_code: product_code, name: name, price: price)
  end

  class Item
    attr_reader :product_code, :name, :price

    def initialize(product_code:, name:, price:)
      @product_code = product_code
      @name = name
      @price = price
    end
  end

  private

  def items
    @items ||= []
  end
end