class MovieWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform movie_id, progress_status_id, title
    movie = Movie.find movie_id
    progress_status = ProgressStatus.find progress_status_id
    if progress_status.status_progress = Settings.status_progress.start
      link_videos = Movie.get_link_from_google_plus title, progress_status_id
    begin
      link_default = link_videos[0]
      if link_videos.size == 2
        link_hd = link_videos[1]
        link_default = link_videos[0]
      end
    rescue
      link_default = ""
      link_hd = ""
    end
      Link.update movie.id, url_default: link_default, url_hd: link_hd,
        embed_link: 0, redirect_url: true
      ProgressStatus.update progress_status_id, status_progress: Settings.status_progress.finished,
        end_time: Time.now, remaining_time: Settings.remaining_time.fnished
    end
  end
end
