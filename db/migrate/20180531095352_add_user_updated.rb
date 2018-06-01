class AddUserUpdated < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :updated, :integer, default: 0
  end
end
