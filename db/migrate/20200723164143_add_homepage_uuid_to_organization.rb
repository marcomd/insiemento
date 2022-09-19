class AddHomepageUuidToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :homepage_data, :jsonb, null: false, default: {}
    add_column :organizations, :homepage_features, :jsonb, null: false, array: true, default: []
    # add_index :organizations, :homepage_data, using: :gin # Doesn't need an index
    add_column :organizations, :uuid, :string, limit: 36
    add_index :organizations, :uuid
    add_index :organizations, :domain
  end
end
