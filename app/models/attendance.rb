class Attendance < ActiveRecord::Base
  belongs_to :user
  validates :seat, numericality: true, presence: true

  # Set default values for `attended_on` and `user`
  before_save{ |attendance| attendance.attended_on ||= Date.today }
  before_save{ |attendance| attendance.user ||= defined?(current_user) ? current_user : nil }
end
