module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def image_tag_link movie
    if movie.images.any?
    else
      images_tag Settings.images.default_movie
    end
  end

  def link_to_movie movie, class_name = nil
    link_to movie_path(id: movie.id) do

    end
  end

  def render_pagination collection
    paginate collection, theme: "twitter-bootstrap-3", pagination_class: "pagination-sm"
  end

  def get_movie movie
    if movie.try(:title).nil?
      movie.impressionable_id = 1 if movie.impressionable_id == 0
      movie = Movie.find movie.impressionable_id
    end
    movie
  end
end
