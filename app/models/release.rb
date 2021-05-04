class Release < ApplicationRecord
  belongs_to :artist
  validates :discogs_release_id, uniqueness: true

  scope :latest, -> do
    joins(:artist).where(
      "releases.created_at >= :today AND artists.created_at <= :today",
      today: Time.zone.today
    )
  end
end
