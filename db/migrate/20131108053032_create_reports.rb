class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :likes_count, default: 0
      t.integer :reposts_count, default: 0
      t.integer :comments_count, default: 0
      t.date :date
      t.references :group
      t.timestamps
    end
    add_index :reports, [:date, :group_id]
  end
end
