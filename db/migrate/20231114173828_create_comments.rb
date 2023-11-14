class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: true, foreign_key: true
      t.text :content
      t.references :comment, null: true, foreign_key: true

      t.timestamps
    end
  end
end
