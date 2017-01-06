class LinksController < ApplicationController
  respond_to :json

  def index
    file = params[:file]
    file.gsub! ".json", ""
    result = []
    links = Link.list_links_api file
    links.flatten.each do |link|
      result << JSON.parse(link)
    end
    render json: result
  end
end
