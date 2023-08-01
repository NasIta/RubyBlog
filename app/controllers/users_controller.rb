class UsersController < ApplicationController
  protect_from_forgery
  def index
    post_data = request.raw_post != "" ? JSON.parse(request.raw_post) : {}

    items_per_page = 5
    page = post_data['page']
    !page && (page = 1)
    offset = items_per_page * (Integer(page) - 1)

    registered_after = post_data['registered_after']
    registered_before = post_data['registered_before']

    users_query = User.order(:id)
    registered_after && (users_query = users_query.where("registered_at::date >= ?", registered_after))
    registered_before && (users_query = users_query.where("registered_at::date <= ?", registered_before))

    total_users = users_query.count
    total_pages = (total_users.to_f / items_per_page).ceil

    @users = users_query.page(page).all

    render json: {
      registered_after: registered_after,
      registered_before: registered_before,
      items_per_page: items_per_page,
      total_users: total_users,
      total_pages: total_pages,
      users: @users
    }
  end

  def get_by_id
    @user = User.includes(posts: :comments).find_by!(id: params[:id])

    @user = @user.as_json(
      include: {
        posts: {
          include: :comments
        }
      }
    )

    render json: { user: @user}
  end

  def create
    @user = User.new(user_params)
    @user.registered_at = Time.now
    @user.posted = 0

    if @user.save
      render json: { user: @user, errors: {} }
    else
      render json: { user: nil, errors: @user.errors }
    end
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
    @user = User.find_by!(id: params[:id])

    message = 'exists, delete them first'
    if @user.posts.count > 0
      @user.errors.add(:posts, message)
    end

    if @user.errors.count == 0
      @user.delete
    end

    render json: { success: @user.errors.count == 0, errors: @user.errors }
  end
end