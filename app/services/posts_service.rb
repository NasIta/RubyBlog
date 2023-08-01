# frozen_string_literal: true

class PostsService

  def create (post_create_params)
    @post = Post.new(post_create_params)

    @post.save

    @user = User.find_by!(id: @post.user_id)
    @user.posted += 1
    @user.save!

    @post
  end

  def destroy_by_id(post_id)
    @post = Post.find_by!(id: post_id)

    @post.delete_children
    @post.delete

    @user = User.find_by!(id: @post.user_id)

    @user.posted -= 1
    @user.save!

    @post
  end
end
