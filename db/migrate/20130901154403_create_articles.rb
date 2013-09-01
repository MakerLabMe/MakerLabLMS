class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :guide_id
      t.text :content

      t.timestamps
    end
  end
end
