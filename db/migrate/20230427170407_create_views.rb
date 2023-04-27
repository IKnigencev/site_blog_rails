class CreateViews < ActiveRecord::Migration[7.0]
  def change
    create_table :views do |t|
      t.references :user,       index: true
      t.references :post,       index: true, null: false

      t.timestamps
    end
  end
end
