class AddExpireOnToUserDocument < ActiveRecord::Migration[6.0]
  def change
    add_column :user_documents, :expire_on, :date
    add_column :user_documents, :uuid, :string, limit: 36
    add_column :user_document_models, :recurring, :boolean
    add_index :user_documents, :expire_on
    add_index :user_documents, :uuid
    add_index :user_documents, :state
    add_index :user_document_models, :state
  end
end
