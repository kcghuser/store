class CartsController < ApplicationController
  def show
    @cart_items = session[:cart] || []
  end

  def add_item
    product = Product.find(params[:product_id])
    size = params[:size]

    session[:cart] ||= []

    session[:cart] << { product_id: product.id, size: size }

    respond_to do |format|
      format.html { redirect_to cart_path, notice: "#{product.name} has been added to your cart." }
      format.json { render json: { message: "#{product.name} added to the cart." }, status: :ok }
    end
  end
end