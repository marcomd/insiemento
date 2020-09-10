class AddSignChecksumToUserDocument < ActiveRecord::Migration[6.0]
  def change
    add_column :user_documents, :sign_checksum, :string, limit: 32
    add_index :users, :firstname
    add_index :users, :lastname
  end
end
