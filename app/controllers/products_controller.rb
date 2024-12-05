class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
    @images = @product.images.page(params[:page]).per(2)  
  end
end