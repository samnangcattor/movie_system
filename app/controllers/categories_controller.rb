class CategoriesController < ApplicationController
  def show
    @category = Category.find params[:id]
    @categories = Rails.cache.fetch("categories") do
      Category.all.order name: :ASC
    end
    @years = Rails.cache.fetch("years") do
      Year.all.order number: :ASC
    end
    @movies = @category.movies.by_no_cinema.page params[:page]
    render layout: "category"
  end
end
