module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :promote, :demote]

    def index
      @users = User.order(created_at: :desc)
      @pagy, @users = pagy(@users, limit: 20)
    end

    def show
      @posts = @user.posts.includes(:category).order(created_at: :desc)
      @pagy, @posts = pagy(@posts, limit: 10)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "You cannot delete yourself."
      else
        @user.destroy
        redirect_to admin_users_path, notice: "User was successfully deleted."
      end
    end

    def promote
      @user.update(role: :admin)
      redirect_to admin_users_path, notice: "#{@user.username} has been promoted to admin."
    end

    def demote
      @user.update(role: :member)
      redirect_to admin_users_path, notice: "#{@user.username} has been demoted to member."
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :bio, :role, :avatar_image)
    end
  end
end
