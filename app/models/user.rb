class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_one_attached :avatar_image

  enum :role, { visitor: 0, member: 1, admin: 2 }, default: :member

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers and underscores" }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def admin?
    role == "admin"
  end

  def member?
    role == "member"
  end

  def display_name
    username.presence || email.split("@").first
  end

  def published_posts_count
    posts.published.count
  end

  def total_views
    posts.sum(:views_count)
  end
end
