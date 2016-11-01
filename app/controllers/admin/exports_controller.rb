class  Admin::ExportsController < Admin::BaseController
  before_action :authenticate_user!, :authorized_admin!

  def index
    @categories = Rails.cache.fetch("categories") do
      Category.all.order name: :ASC
    end
    @years = Rails.cache.fetch("years") do
      Year.all.order number: :ASC
    end
  end

  def create
    category = Category.includes(:movies).find_by name: "18+"
    movies = category.movies
    file_path = Export.create_xlsx movies
    send_file file_path
  end

  private
  def authorized_admin!
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
