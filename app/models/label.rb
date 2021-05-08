class Label < ApplicationRecord
  has_many :follows, dependent: :destroy, as: :followable
  has_many :releases, dependent: :destroy
  validates :discogs_label_id, presence: true, uniqueness: true
end
