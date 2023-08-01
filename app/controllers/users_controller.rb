class UsersController < ApplicationController
  protect_from_forgery

  def index
    post_data = request.raw_post != "" ? JSON.parse(request.raw_post) : {}

    users_service = UsersService.new
    result = users_service.filter_users(post_data)

    render json: result
  end

  def get_by_id
    users_service = UsersService.new
    user = users_service.get_by_id(params[:id])

    render json: { user: user}
  end

  def create
    users_service = UsersService.new
    @user = users_service.create(user_params)

    render json: { user: @user, errors: @user.errors }
  end

  def user_params
    params.require(:user).permit(:name)
  end

  def update
    @user = User.find_by!(id: params[:id])

    @user.update(user_params)

    render json: { user: @user, errors: @user.errors }
  end

  def delete
    users_service = UsersService.new
    @user = users_service.delete_by_id(params[:id])

    render json: { success: @user.errors.count == 0, errors: @user.errors }
  end
end