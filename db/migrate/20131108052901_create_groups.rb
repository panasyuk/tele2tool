class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :url, null: true
      t.string :screen_name, null: true
      t.timestamps
    end
    add_index :groups, :screen_name, unique: true
  end
end
