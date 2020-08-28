class CreateUserDocumentModels < ActiveRecord::Migration[6.0]
  def change
    create_table :user_document_models do |t|
      t.references :organization, null: false, foreign_key: true
      t.integer :state, limit: 1
      t.string :title, limit: 255
      t.text :body
      t.integer :validity_days, limit: 2

      t.timestamps
    end
  end
end
