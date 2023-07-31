class UsersController < ApplicationController
  protect_from_forgery
  def index
    post_data = JSON.parse(request.raw_post)

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

    users = users_query.offset(offset).limit(items_per_page).all

    respond_to do |format|
      format.json { render :json => {
        registered_after: registered_after,
        registered_before: registered_before,
        items_per_page: items_per_page,
        total_users: total_users,
        total_pages: total_pages,
        users: users
      } }
    end
  end

  def get_by_id
    user = User.includes(posts: :comments).find_by(id: params[:id])

    if user == nil
      raise ActionController::RoutingError.new('Not Found')
    end

    user = user.as_json(
      include: {
        posts: {
          include: :comments
        }
      }
    )

    respond_to do |format|
      format.json { render :json => {
        user: user
      } }
    end
  end

  def create
    post_data = JSON.parse(request.raw_post)

    user = User.create(
      name: post_data['name'],
      registered_at: Time.now,
      posted: 0
    )

    user.save

    respond_to do |format|
      format.json { render :json => {
        user: user
      } }
    end
  end

  def update
    post_data = JSON.parse(request.raw_post)

    user = User.find_by(id: params[:id])

    if user == nil
      raise ActionController::RoutingError.new('Not Found')
    end

    user.name = post_data['name']
    user.save

    respond_to do |format|
      format.json { render :json => {
        user: user
      } }
    end
  end

  def delete
    user = User.find_by(id: params[:id])

    if user == nil
      raise ActionController::RoutingError.new('Not Found')
    end

    message = 'exists, delete them first'
    if user.posts.count > 0
      user.errors.add(:posts, message)
    end

    if user.errors.count == 0
      user.delete
    end

    respond_to do |format|
      format.json { render :json => {
        success: user.errors.count == 0,
        errors: user.errors.full_messages
      } }
    end
  end
end