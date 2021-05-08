class User < ApplicationRecord
  has_many :follows, dependent: :destroy
  has_many :artists, through: :follows,
                     source: :followable,
                     source_type: "Artist"
  has_many :labels, through: :follows,
                    source: :followable,
                    source_type: "Label"

  has_secure_password
  before_save { self.email = email.downcase }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }

  def artist_follows
    follows.where(followable_type: "Artist")
  end
end
