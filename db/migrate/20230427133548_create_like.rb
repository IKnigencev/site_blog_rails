class CreateLike < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user,       index: true
      t.references :post,       index: true, null: true
      t.references :comment,    index: true, null: true

      t.timestamps
    end
  end
end
