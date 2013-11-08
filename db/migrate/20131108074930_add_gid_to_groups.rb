class AddGidToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :gid, :integer
  end
end
