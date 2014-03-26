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

  # Import assignments from a string in CSV format
  def self.import(csv_data)
    imported = 0
    csv_data.each_line do |line|
      fields = line.split(",")
      email = fields[0].strip
      assignment_name = fields[1].strip
      total = fields[2].strip
      score = fields[3].strip
      # If there's a user who has this email
      user = User.find_by_email(email)
      if not user.nil? and user.is_student?
        assignment = Assignment.where(user: user, name: assignment_name).first
        if assignment.nil?
          if Assignment.create(user: user, name: assignment_name, total: total, score: score)
            imported += 1
          end
        else
          if assignment.update(total: total, score: score)
          
          end
        end
      end
    end
    imported
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
