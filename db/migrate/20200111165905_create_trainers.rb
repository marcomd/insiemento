class CreateTrainers < ActiveRecord::Migration[6.0]
  def change
    create_table :trainers do |t|
      t.string :firstname, limit: 30
      t.string :lastname, limit: 30
      t.string :nickname, limit: 30
      t.text :bio

      t.timestamps
    end
  end
end
