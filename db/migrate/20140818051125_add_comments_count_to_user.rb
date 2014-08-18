class AddCommentsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :comments_count, :integer, :default => 0
    User.find_each do |user|
      user.update_column(:comments_count, user.comments.count)
    end
  end
end
