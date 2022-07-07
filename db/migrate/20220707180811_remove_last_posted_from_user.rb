class RemoveLastPostedFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :last_posted, :timestamp
  end
end
