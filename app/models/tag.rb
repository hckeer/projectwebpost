class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  scope :popular, -> {
    left_joins(:posts)
      .where(posts: { status: :published })
      .group(:id)
      .order('COUNT(posts.id) DESC')
  }

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
