class Label < ApplicationRecord
  validates :discogs_label_id, uniqueness: true
end
