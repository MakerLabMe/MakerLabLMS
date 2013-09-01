class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :title
      t.integer :user_id
      t.integer :category_id
      t.string :subtitle
      t.string :overview
      t.string :img

      t.timestamps
    end
  end
end
