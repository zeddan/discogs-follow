class Artist < ApplicationRecord
  has_many :releases, dependent: :destroy
  validates :artist_id, uniqueness: true
end
