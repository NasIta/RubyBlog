# frozen_string_literal: true

class UsersService
  def filter_users(data)
    items_per_page = 5
    page = data['page']
    !page && (page = 1)

    registered_after = data['registered_after']
    registered_before = data['registered_before']

    users_query = User.order(:id)
    registered_after && (users_query = users_query.where("registered_at::date >= ?", registered_after))
    registered_before && (users_query = users_query.where("registered_at::date <= ?", registered_before))

    total_users = users_query.count
    total_pages = (total_users.to_f / items_per_page).ceil

    users = users_query.page(page).all

    {
      registered_after: registered_after,
      registered_before: registered_before,
      items_per_page: items_per_page,
      total_users: total_users,
      total_pages: total_pages,
      users: users
    }
  end

  def create(user_params)
    @user = User.new(user_params)
    @user.registered_at = Time.now
    @user.posted = 0

    @user.save

    @user
  end

  def get_by_id(user_id)
    @user = User.includes(posts: :comments).find_by!(id: user_id)

    @user.as_json(
      include: {
        posts: {
          include: :comments
        }
      }
    )
  end

  def delete_by_id (user_id)
    @user = User.find_by!(id: user_id)

    message = 'exists, delete them first'
    if @user.posts.count > 0
      @user.errors.add(:posts, message)
    end

    if @user.errors.count == 0
      @user.delete
    end

    @user
  end
end