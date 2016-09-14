class YearsController < ApplicationController
  def show
    @year = Year.find params[:id]
    @categories = Rails.cache.fetch("categories") do
      Category.all.order name: :ASC
    end
    @years = Rails.cache.fetch("years") do
      Year.all.order number: :ASC
    end
    @movies = @year.movies.by_no_cinema.page params[:page]
  end
end
