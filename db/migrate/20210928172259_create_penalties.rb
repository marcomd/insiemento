class CreatePenalties < ActiveRecord::Migration[6.1]
  def change
    create_table :penalties do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :course, null: true, foreign_key: true
      t.integer :state, limit: 1
      t.integer :days, limit: 2

      t.timestamps
    end
    # add_column :attendees, :inhibited_until, :date
    # add_index :attendees, :inhibited_until
    change_column_default :attendees, :presence, from: nil, to: false
    reversible do |dir|
      dir.up do
        Attendee.where(presence: nil).update_all(presence: false)
      end
    end
  end
end
