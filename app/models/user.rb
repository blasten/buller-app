class User < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }
  validates :nickname, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: /\A[a-zA-Z0-9_-]{1,}@[a-zA-Z0-9_-]{1,}\.[a-zA-Z0-9_-]{2,}\z/, message: "Invalid email format" }

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
