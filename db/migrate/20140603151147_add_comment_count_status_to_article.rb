class AddCommentCountStatusToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :comments_count, :integer, :default => 0
    add_column :articles, :comments_closed, :boolean, :default => false
  end
end
