class CategoriesController < ApplicationController
  def show
    @category = Category.find params[:id]
    @categories = Category.all.order(name: :ASC)
    @movies = @category.movies.order(created_at: :DESC).page params[:page]
    render layout: "category"
  end
end
