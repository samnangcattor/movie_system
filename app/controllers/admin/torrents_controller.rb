class  Admin::TorrentsController < ApplicationController
  before_action :authenticate_user!, :authorized_admin!

  def index
    torrent_movie = params[:torrent]
    if torrent_movie.present?
      torrent_movie[:genre] = torrent_movie[:genre].split "\r\n"
      Resque.enqueue TorrentsWorker, torrent_movie
    end
  end

  private
  def authorized_admin!
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
