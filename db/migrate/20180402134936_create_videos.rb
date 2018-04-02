class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.string :description
      t.string :small_cover_url, :large_cover_url
      t.timestamps
    end
  end
end
