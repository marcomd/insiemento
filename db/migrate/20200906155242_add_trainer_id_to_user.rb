class AddTrainerIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :trainer, null: true, foreign_key: true
    add_reference :attendees, :organization, null: true, foreign_key: true
    add_column :attendees, :presence, :boolean
    add_column :course_events, :auditor_id, :integer, limit: 4

    reversible do |dir|
      dir.up do
        # Let's add relations before making them mandatory
        sql = <<-SQL.gsub('          ', ' ')
          UPDATE attendees SET organization_id = U.organization_id
          FROM attendees A
          INNER JOIN users U ON U.id = A.user_id;
        SQL
        ActiveRecord::Base.connection.execute(sql)

        # With relations we can make foreign keys mandatory
        change_column_null :attendees, :organization_id, false
      end
    end
  end
end
