class CreateSystemLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :system_logs do |t|
      t.references :organization, null: false, foreign_key: true
      t.integer :log_level, limit: 2
      t.string :message

      t.timestamps
    end
  end
end
