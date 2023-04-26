class CreatePost < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.string :title,    null: false
      t.text :text,       null: false
      t.integer :views,   default: 0
      t.integer :likes,   default: 0

      t.timestamps
    end
  end
end
