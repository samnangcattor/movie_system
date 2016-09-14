class LinksController < ApplicationController
  def index
    movie = params[:movie]
    @plain = Base64.decode64 movie if movie.present?
  end
end
