require_relative '../models/product'

class ProductsInteractor
  @products = {}
  @next_id = 1

  class << self
    attr_accessor :products, :next_id

    def create_product(product_name)
      product = Product.new(next_id, product_name)
      products[product.id] = product
      self.next_id += 1
      product
    end

    def get_products
      products.values
    end
  end
end
