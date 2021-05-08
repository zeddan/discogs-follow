class Artist < ApplicationRecord
  has_many :follows, dependent: :destroy, as: :followable
  has_many :releases, dependent: :destroy
  validates :discogs_artist_id, uniqueness: true
end
