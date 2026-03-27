class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :published, -> { where(published: true) }
  scope :search, ->(query) { where("title LIKE ? OR body LIKE ?", "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%") }
  scope :with_tag, ->(tag) { where("tags LIKE ?", "%#{sanitize_sql_like(tag)}%") }

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:empty?)
  end

  def tag_list=(value)
    self.tags = value.to_s.split(",").map(&:strip).reject(&:empty?).join(", ")
  end
end
