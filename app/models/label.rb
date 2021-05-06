class Label < ApplicationRecord
  has_many :releases, dependent: :destroy
  validates :discogs_label_id, uniqueness: true
end
