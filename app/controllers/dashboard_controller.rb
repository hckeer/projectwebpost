class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts.includes(:category, :tags).order(created_at: :desc)
    @pagy, @posts = pagy(:offset, @posts, limit: 10)

    @stats = {
      total_posts: current_user.posts.count,
      published_posts: current_user.posts.published.count,
      draft_posts: current_user.posts.drafts.count,
      total_views: current_user.total_views
    }
  end
end
