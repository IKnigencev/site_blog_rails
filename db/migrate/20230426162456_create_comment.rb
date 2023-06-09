class CreateComment < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :post,   index: true
      t.references :user,   index: true
      t.text       :text,   null: false

      t.timestamps
    end
  end
end
