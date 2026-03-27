class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :published, -> { where(published: true) }
  scope :search, ->(query) { where("title LIKE ? OR body LIKE ?", "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%") }
  scope :with_tag, ->(tag) { where("tags LIKE ?", "%#{sanitize_sql_like(tag)}%") }
  scope :sorted_by, ->(order) {
    case order
    when "oldest"  then order(created_at: :asc)
    when "popular" then order(views_count: :desc)
    else                order(created_at: :desc)
    end
  }

  def reading_time
    words = body.to_s.split.size
    minutes = [(words / 200.0).ceil, 1].max
    "#{minutes} min read"
  end

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:empty?)
  end

  def tag_list=(value)
    self.tags = value.to_s.split(",").map(&:strip).reject(&:empty?).join(", ")
  end
end
