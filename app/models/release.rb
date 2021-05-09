class Release < ApplicationRecord
  belongs_to :artist
  belongs_to :label
  validates :discogs_release_id, presence: true
  validates :release_date, presence: true
  validates :label_id, presence: true
  validates :discogs_release_id, uniqueness: { scope: :label_id }

  scope :latest, -> do
    joins(:artist).where(
      "releases.created_at >= :today AND artists.created_at <= :today",
      today: Time.zone.today
    )
  end
end
