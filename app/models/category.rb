class Category < ApplicationRecord
  has_many :posts, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  scope :with_posts, -> { joins(:posts).where(posts: { status: :published }).distinct }

  def to_param
    slug
  end

  def posts_count
    posts.published.count
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
