class LinksController < ApplicationController
  respond_to :json

  def index
    file = params[:file]
    links = nil
    result = []
    links = Link.list_links file
    links.each do |link|
      result << JSON.parse(link)
    end
    respond_with video, json: result
  end
end
