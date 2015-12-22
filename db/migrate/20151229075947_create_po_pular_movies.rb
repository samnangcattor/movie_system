class CreatePoPularMovies < ActiveRecord::Migration
  def change
    create_table :po_pular_movies do |t|
      t.text :photo
      t.text :link
      t.string :title

      t.timestamps null: false
    end
  end
end
