class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :vk_id
      t.integer :likes_count, default: 0
      t.integer :reposts_count, default: 0
      t.integer :comments_count, default: 0
      t.string :type
      t.integer :author_id
      t.text :text
      t.datetime :published_at
      t.references :group
      t.timestamps
    end

    add_index :posts, [:published_at, :group_id]
  end
end
