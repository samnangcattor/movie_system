class LinksController < ApplicationController
  respond_to :json

  def index
    file = params[:file]
    file.gsub! ".json", ""
    links = Link.list_links file
    render json: links.flatten
  end
end
