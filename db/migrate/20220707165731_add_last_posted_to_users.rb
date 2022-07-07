class AddLastPostedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_posted, :timestamp, default: 5.days.ago
  end
end
