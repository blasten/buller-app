class User < ActiveRecord::Base
  # Includes ActiveModel::SecurePassword
  # Adds methods to set and authenticate against a BCrypt password. 
  # This mechanism requires you to have a password_digest attribute.

  # Validations for presence of password on create, confirmation of 
  # password (using a password_confirmation attribute) are automatically added. 
  # If you wish to turn off validations, pass validations: false as an argument. 
  # You can add more validations by hand if need be.
  
  has_secure_password

  # Model validations
  validates :name, presence: true, length: { minimum: 2 }
  validates :nickname, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: /\A[a-zA-Z0-9_\.-]{1,}@[a-zA-Z0-9_\.-]{1,}\.[a-zA-Z0-9_-]{2,}\z/, message: "Invalid email format" }

  # Redefines the image_url getter
  # If image_url is empty it will fallback to gravatar's image
  def image_url
    src = read_attribute(:image_url).downcase
    src.strip!

    if src.length==0
      hash = Digest::MD5.hexdigest(read_attribute(:email).downcase)
      return "http://www.gravatar.com/avatar/#{hash}"
    else 
      return src
    end
  end
end
