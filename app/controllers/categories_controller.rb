class CategoriesController < ApplicationController
  def show
    @q = Movie.ransack(params[:q])
    @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
    @category = Category.find params[:id]
    @categories = Category.all.order(name: :ASC)
    @movies = @category.movies.order(created_at: :DESC).page params[:page]
    render layout: "category"
  end
end
