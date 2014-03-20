class User < ActiveRecord::Base
  # Includes ActiveModel::SecurePassword
  # Adds methods to set and authenticate against a BCrypt password. 
  # This mechanism requires you to have a password_digest attribute.

  # Validations for presence of password on create, confirmation of 
  # password (using a password_confirmation attribute) are automatically added. 
  # If you wish to turn off validations, pass validations: false as an argument. 
  # You can add more validations by hand if need be.

  # User roles

  ROLE_STUDENT = 1
  ROLE_ADMIN = 2

  # Encrypt password using MD5 digest hashing
  
  has_secure_password

  # Validations

  validates :name, presence: true, length: { minimum: 2 }
  validates :nickname, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9_\.-]{1,}@[a-zA-Z0-9_\.-]{1,}\.[a-zA-Z0-9_-]{2,}\z/, message: "Invalid email format" }

  # A user can have many attandances

  has_many :attendances
  has_many :assignments

  # Use lowercase email before saving the model

  before_save { |user| user.email = email.downcase }

  # Make a student user by default

  before_save{ |user| user.role ||= ROLE_STUDENT}
  
  # Create a unique token before saving the model

  before_save :create_remember_token

  # Redefines the image_url getter
  # If image_url is empty it will fallback to gravatar's image

  def image_url
    src = read_attribute(:image_url).downcase
    src.strip!

    if src.length==0
      hash = Digest::MD5.hexdigest(read_attribute(:email).downcase)
      "http://www.gravatar.com/avatar/#{hash}"
    else 
      src
    end
  end

  # Returns true if this user is a student
  # Ideally this field should be type `ENUM`, but rails migrations don't offer that type
  def is_student?
    read_attribute(:role) == ROLE_STUDENT
  end

  # Returns true if this user is an admin
  def is_admin?
    read_attribute(:role) == ROLE_ADMIN
  end

  def current_grade
    ( assignments.count>0 ) ? assignments.sum("100*score/total") / assignments.count : 0;
  end

  # Returns the list of students who attended on `date` and sat down on `seat`
  def self.in_seat(seat, date)
    User.joins(:attendances).where(attendances: {seat: seat, attended_on: date});
  end

  # Returns the list of absent students
  # where.not should be similar to
  # `SELECT U.* FROM user U WHERE U.id NOT IN(SELECT A.id_user FROM attedance A FROM A.date=?)`

  def self.absent(date)
    User.joins(:attendances).where("role = ? and attendances.attended_on != ?", ROLE_STUDENT, date);
  end

  # Gets all the students

  def self.get_all_students
    User.where(:role => ROLE_STUDENT)
  end

  private
    # Creates a unique token that kill be sent to the client 
    # as a cookie to allow the user to sign in.

    def create_remember_token
      if self.remember_token.nil? || self.remember_token.empty?
        self.remember_token = SecureRandom.urlsafe_base64
      end
    end
end
