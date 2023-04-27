class CreatePost < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.string :title,    null: false
      t.text :text,       null: false

      t.timestamps
    end
  end
end
