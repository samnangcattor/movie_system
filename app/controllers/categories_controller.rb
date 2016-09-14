class CategoriesController < ApplicationController
  def show
    @category = Category.find params[:id]
    @categories = Category.all.order name: :ASC
    @years = Year.all.order number: :ASC
    @movies = @category.movies.by_no_cinema.page params[:page]
    render layout: "category"
  end
end
