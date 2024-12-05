class HomeController < ApplicationController
  def index
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @main_categories = Category.where("LOWER(name) LIKE ?", search_term).page(params[:page]).per(10)
    else
      @main_categories = Category.page(params[:page]).per(10)
    end
  end
end