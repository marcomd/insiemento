class CreateUserDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :user_documents do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user_document_model, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :state, limit: 1
      t.string :title, limit: 255
      t.text :body

      t.timestamps
    end
  end
end
