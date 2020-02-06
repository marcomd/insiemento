class CreateSystemLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :system_logs do |t|
      t.integer :log_level, limit: 2
      t.string :message

      t.timestamps
    end
  end
end
