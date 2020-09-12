class AddAnalyticsTagToOrganization < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :analytics_tag, :string, limit: 32
  end
end
