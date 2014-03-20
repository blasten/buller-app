class Assignment < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, length: { minimum: 2 }
  validates :score, numericality: true, presence: true
  validates :total, numericality: {greater_than_or_equal_to: 0.1}, presence: true

  # Verify that `user_id` is actually a student
  validate :verify_student

  def percentage
    score/total*100
  end

  def self.average_percentage
    self.all.count>0 ? self.sum("100*score/total")/self.all.count : 0
  end

  private
  def verify_student
    if user_id.present?
      if not User.find(user_id).is_student?
        errors.add(:user_id, 'invalid')
      end
    else
      errors.add(:user_id, 'invalid')
    end
  end
end
