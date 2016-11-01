class Export
  class << self
    def create_xlsx movies
      xlsx = []
      p = Axlsx::Package.new
      p.workbook.add_worksheet do |sheet|
        movies.each do |movie|
          sheet.add_row [movie.title, movie.photo, movie.description, movie.year_number, movie.link.file_id]
        end
      end
      tempfile = "#{Rails.root.to_s}/public/movie.xlsx"
      p.serialize tempfile
      tempfile
    end
  end
end
