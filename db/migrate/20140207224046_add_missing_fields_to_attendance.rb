class AddMissingFieldsToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :attended_on, :date
    add_column :attendances, :seat, :integer 
  end
end
