class MovieWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform movie_id, progress_status_id, title
    movie = Movie.find movie_id
    begin
      link_videos = GooglePlus.upload title, progress_status_id
      link_default = link_videos[0].url
      if link_videos.size == 2
        link_default = link_videos[0].url
        link_hd = link_videos[1].url
        link_super_hd = ""
      elsif link_videos.size == 3
        link_default = link_videos[0].url
        link_hd = link_videos[1].url
        link_super_hd = link_videos[2].url
      end
    rescue
      link_default = ""
      link_hd = ""
      ProgressStatus.update progress_status_id, status_progress: Settings.status_progress.finished,
        end_time: Time.now, remaining_time: Settings.remaining_time.fnished
    end
    Link.update movie.id, url_default: link_default, url_hd: link_hd, ulr_super_hd: link_super_hd,
      embed_link: 0, redirect_url: true
    ProgressStatus.update progress_status_id, status_progress: Settings.status_progress.finished,
      end_time: Time.now, remaining_time: Settings.remaining_time.fnished
  end
end
