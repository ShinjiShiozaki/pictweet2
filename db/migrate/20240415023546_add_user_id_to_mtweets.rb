class AddUserIdToMtweets < ActiveRecord::Migration[7.0]
  def change
    add_column :mtweets, :user_id, :integer
  end
end
