class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.decimal :score
      t.decimal :total
      t.integer :user_id

      t.timestamps
    end
  end
end
