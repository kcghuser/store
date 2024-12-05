class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
  def show
    @category = Category.find(params[:id])
    @products = @category.products
    if params[:max].present?
      @products = @products.where("price <= ?", params[:max])
    end
    if params[:min].present?
      @products = @products.where("price >= ?", params[:min])
    end
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where("LOWER(name) LIKE ?", search_term)
    end
    if params[:new].present? && params[:new] == "true"
      @products = @products.where("created_at >= ?", 3.days.ago)
    end
    if params[:recently_updated].present? && params[:recently_updated] == "true"
      @products = @products.where("updated_at >= ?", 3.days.ago)
    end
    @products = @products.page(params[:page]).per(5)
  end
end
