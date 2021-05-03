class Release < ApplicationRecord
  belongs_to :artist
  validates :release_id, uniqueness: true
end
