class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_rich_text :content
  has_many_attached :images

  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft

  validates :title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :slug, presence: true, uniqueness: true
  validates :category, presence: true

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  scope :published, -> { where(status: :published) }
  scope :drafts, -> { where(status: :draft) }
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(views_count: :desc) }

  def to_param
    slug
  end

  def reading_time
    words_per_minute = 200
    words = content.to_plain_text.split.size rescue 0
    minutes = (words / words_per_minute.to_f).ceil
    minutes < 1 ? 1 : minutes
  end

  def increment_views!
    increment!(:views_count)
  end

  private

  def generate_slug
    base_slug = title.parameterize
    slug_candidate = base_slug
    counter = 1

    while Post.exists?(slug: slug_candidate)
      slug_candidate = "#{base_slug}-#{counter}"
      counter += 1
    end

    self.slug = slug_candidate
  end
end
