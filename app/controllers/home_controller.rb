class HomeController < ApplicationController
  def index
    @main_categories = Category.take(25)
  end
end
