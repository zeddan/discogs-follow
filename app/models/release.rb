class Release < ApplicationRecord
  belongs_to :artist
  validates :release_id, uniqueness: true
  scope :latest, -> { where("created_at >= ?", Time.zone.today) }
end
