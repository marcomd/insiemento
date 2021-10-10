class CreateUserPenalties < ActiveRecord::Migration[6.1]
  def change
    create_table :user_penalties do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.references :course_event, null: false, foreign_key: true
      t.references :attendee, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :course, null: true, foreign_key: true
      t.date :inhibited_until

      t.timestamps
    end
    add_index :user_penalties, :inhibited_until
  end
end
