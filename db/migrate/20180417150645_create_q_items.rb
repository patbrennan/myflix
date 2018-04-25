class CreateQItems < ActiveRecord::Migration
  def change
    create_table :q_items do |t|
      t.integer :video_id, :user_id
      t.integer :position
      t.timestamps
    end
  end
end
