module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        total_users: User.count,
        total_posts: Post.count,
        published_posts: Post.published.count,
        total_views: Post.sum(:views_count),
        new_users_this_week: User.where("created_at >= ?", 1.week.ago).count,
        new_posts_this_week: Post.where("created_at >= ?", 1.week.ago).count
      }

      @recent_posts = Post.includes(:user, :category).order(created_at: :desc).limit(5)
      @recent_users = User.order(created_at: :desc).limit(5)
    end
  end
end
