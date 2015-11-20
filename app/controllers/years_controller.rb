class YearsController < ApplicationController
  def show
    q = Hash.new
    q[:title_cont] = params[:search]
    @q = Movie.ransack q
    @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
    @year = Year.find params[:id]
    @categories = Category.all.order(name: :ASC)
    @years = Year.all.order(number: :ASC)
    @movies = @year.movies.order(created_at: :DESC).page params[:page]
  end
end
