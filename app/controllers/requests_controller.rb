class RequestsController < ApplicationController
  before_action :header_action

  def new
    @request = Request.new
  end

  def create
    request = Request.new request_params
    if request.save
      render :show
    else
      render :new
    end
  end

  def show
    @request = Request.find params[:id]
  end

  private
  def request_params
    params.require(:request).permit :name, :description
  end

  def header_action
    @q = Movie.ransack params[:q]
    @movie_searchs = @q.result(distinct: true).order(created_at: :DESC).page params[:page]
    @categories = Category.all.order name: :ASC
    @years = Year.all.order number: :ASC
  end
end
