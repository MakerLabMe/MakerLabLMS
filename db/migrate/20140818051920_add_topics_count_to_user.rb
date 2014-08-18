class AddTopicsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :topics_count, :integer, :default => 0
    User.find_each do |user|
      user.update_column(:topics_count, user.topics.count)
    end
  end
end
