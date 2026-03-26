class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :published, -> { where(published: true) }
end
