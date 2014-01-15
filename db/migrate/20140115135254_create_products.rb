class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :img
      t.text :descrption

      t.timestamps
    end
  end
end
