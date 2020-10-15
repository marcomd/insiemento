class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news do |t|
      t.references :organization, null: false, foreign_key: true
      t.integer :state, limit: 1
      t.string :title, limit: 127
      t.string :body, limit: 255
      t.date :expire_on
      t.integer :news_type, limit: 1
      t.boolean :dark_style, default: false
      t.boolean :public, default: false
      t.boolean :private, default: false

      t.timestamps
    end
    add_index :news, :state
    add_index :news, :expire_on
    add_index :news, :public
    add_index :news, :private
  end
end
