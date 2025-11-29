class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :publish, :archive ]

  def index
    @posts = policy_scope(Post).published.includes(:user, :category, :tags, images_attachments: :blob)

    if params[:category].present?
      @category = Category.find_by(slug: params[:category])
      @posts = @posts.where(category: @category) if @category
    end

    if params[:tag].present?
      @tag = Tag.find_by(slug: params[:tag])
      @posts = @posts.joins(:tags).where(tags: { id: @tag.id }) if @tag
    end

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @posts = @posts.where("title LIKE ? OR excerpt LIKE ?", search_term, search_term)
    end

    @posts = @posts.order(created_at: :desc)
    @pagy, @posts = pagy(:offset, @posts, limit: 12)
  end

  def show
    authorize @post
    @post.increment_views! unless @post.user == current_user
    @related_posts = Post.published
                         .where(category: @post.category)
                         .where.not(id: @post.id)
                         .limit(3)
  end

  def new
    @post = current_user.posts.build
    authorize @post
    @categories = Category.all
    @tags = Tag.all
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    if @post.save
      update_tags
      redirect_to @post, notice: "Post was successfully created."
    else
      @categories = Category.all
      @tags = Tag.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @post
    @categories = Category.all
    @tags = Tag.all
  end

  def update
    authorize @post

    if @post.update(post_params)
      update_tags
      redirect_to @post, notice: "Post was successfully updated."
    else
      @categories = Category.all
      @tags = Tag.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to dashboard_path, notice: "Post was successfully deleted."
  end

  def publish
    authorize @post
    @post.update(status: :published)
    redirect_to @post, notice: "Post has been published."
  end

  def archive
    authorize @post
    @post.update(status: :archived)
    redirect_to dashboard_path, notice: "Post has been archived."
  end

  private

  def set_post
    @post = Post.find_by!(slug: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :excerpt, :content, :category_id, :status, :featured, images: [])
  end

  def update_tags
    if params[:post][:tag_ids].present?
      @post.tag_ids = params[:post][:tag_ids].reject(&:blank?)
    end
  end
end
