class Artist < ApplicationRecord
  has_many :releases, dependent: :destroy
end
