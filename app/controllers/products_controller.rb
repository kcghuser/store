class ProductsController < ApplicationController
  include Pagy::Backend
  def show
    @pagy, @product = Product.find(params[:id])
  end
end
