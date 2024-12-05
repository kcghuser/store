class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products
    if params[:max].present?
      @products = @products.where("price <= ?", params[:max])
    end
    if params[:min].present?
      @products = @products.where("price >= ?", params[:min])
    end
    @products = @products.page(params[:page]).per(5)
  end
end
