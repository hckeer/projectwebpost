module Admin
  class PostsController < BaseController
    before_action :set_post, only: [ :show, :edit, :update, :destroy, :publish, :archive ]

    def index
      @posts = Post.includes(:user, :category, :tags).order(created_at: :desc)

      if params[:status].present?
        @posts = @posts.where(status: params[:status])
      end

      if params[:user_id].present?
        @posts = @posts.where(user_id: params[:user_id])
      end

      @pagy, @posts = pagy(:offset, @posts, limit: 20)
    end

    def show
    end

    def edit
      @categories = Category.all
      @tags = Tag.all
    end

    def update
      if @post.update(post_params)
        update_tags
        redirect_to admin_post_path(@post), notice: "Post was successfully updated."
      else
        @categories = Category.all
        @tags = Tag.all
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: "Post was successfully deleted."
    end

    def publish
      @post.update(status: :published)
      redirect_to admin_posts_path, notice: "Post has been published."
    end

    def archive
      @post.update(status: :archived)
      redirect_to admin_posts_path, notice: "Post has been archived."
    end

    private

    def set_post
      @post = Post.find_by!(slug: params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :excerpt, :content, :category_id, :status, :featured, :user_id, images: [])
    end

    def update_tags
      if params[:post][:tag_ids].present?
        @post.tag_ids = params[:post][:tag_ids].reject(&:blank?)
      end
    end
  end
end
