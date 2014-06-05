class AddLastInvolvedToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :involved_at, :datetime
    add_column :articles, :last_replied_by, :string, :default => ""
    add_column :articles, :last_replied_at, :datetime
    add_column :articles, :hit, :integer
    add_column :articles, :user_id, :integer
    add_index :articles, :involved_at
    add_index :articles, :guide_id
    add_index :articles, :user_id
    Article.all.each do |article|
      article.update_column(:involved_at, article.updated_at)
    end
  end

  def down
    remove_index :articles, :involved_at
    remove_index :articles, :guide_id
    remove_index :articles, :user_id
    remove_column :articles, :hit
    remove_column :articles, :user_id
    remove_column :articles, :involved_at
    remove_column :articles, :last_replied_by
    remove_column :articles, :last_replied_at
  end
end
