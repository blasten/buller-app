class Attendance < ActiveRecord::Base
  belongs_to :user
  validates :seat, numericality: true, presence: true

end
