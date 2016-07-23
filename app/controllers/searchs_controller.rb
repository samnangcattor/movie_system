class SearchsController < ApplicationController
  def index
    @categories = Category.all.order name: :ASC
    @years = Year.all.order number: :ASC
  end
end
