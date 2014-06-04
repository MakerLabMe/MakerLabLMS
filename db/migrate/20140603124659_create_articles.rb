class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :guide_id
      t.text :content
      t.string :complete

      t.timestamps
    end
  end
end
