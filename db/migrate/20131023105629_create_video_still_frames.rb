class CreateVideoStillFrames < ActiveRecord::Migration
  def change
    create_table :video_still_frames do |t|
      t.text :video_id
      t.integer :frame_id
      t.binary :frame

      t.timestamps
    end
  end
end
