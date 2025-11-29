class HomeController < ApplicationController
  def index
    # Show latest posts in featured section instead of featured=true posts
    @featured_posts = Post.published.recent.includes(:user, :category, :tags, images_attachments: :blob).limit(3)
    @recent_posts = Post.published.recent.includes(:user, :category, :tags, images_attachments: :blob).limit(6)
    @categories = Category.with_posts.limit(6)
    @popular_tags = Tag.popular.limit(10)
  end

  def about
  end

  def contact
  end

  def toggle_theme
    new_theme = current_theme == "light" ? "dark" : "light"
    cookies[:theme] = { value: new_theme, expires: 1.year.from_now }

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end
end
