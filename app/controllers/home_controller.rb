class HomeController < ApplicationController
  def index
    @main_categories = Category.page(params[:page]).per(5)
  end
end
