class AddHomepageContactsToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :homepage_contacts, :jsonb, null: false, array: true, default:[]
    add_column :organizations, :homepage_socials, :jsonb, null: false, array: true, default:[]
  end
end
