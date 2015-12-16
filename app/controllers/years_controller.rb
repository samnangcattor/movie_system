class YearsController < ApplicationController
  def show
    q = Hash.new
    q[:title_cont] = params[:search]
    @q = Movie.ransack q
    @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
    @year = Year.find params[:id]
    @categories = Rails.cache.fetch("categories") do
      Category.all.order name: :ASC
    end
    @years = Rails.cache.fetch("years") do
      Year.all.order number: :ASC
    end
    @movies = @year.movies.order(created_at: :DESC).page params[:page]
  end
end
