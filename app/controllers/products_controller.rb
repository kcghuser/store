class ProductsController < ApplicationController
  include Pagy::Backend
  def show
    @pagy, @product = Product.find(params[:id])
    @product = Product.find_by(id: params[:id])
    unless @product
      redirect_to products_path, alert: "Product not found"
    end
    
  end
end
