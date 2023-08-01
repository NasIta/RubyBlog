class PostsController < ApplicationController
  protect_from_forgery

  def create
    @post = Post.new(post_create_params)

    @post.save

    @user = User.find_by!(id: @post.user_id)
    @user.posted += 1
    @user.save

    render json: {
      post: @post,
      errors: @post.errors.merge!(@user.errors)
    }
  end

  def post_create_params
    params.require(:post).permit(:title, :text, :user_id)
  end

  def post_update_params
    params.require(:post).permit(:title, :text)
  end

  def update
    @post = Post.find_by!(id: params[:id])
    @post.update(post_update_params)

    render json: {
      post: @post,
      errors: @post.errors
    }
  end

  def destroy
    @post = Post.find_by!(id: params[:id])

    @post.delete_children
    @post.delete

    @user = User.find_by!(id: @post.user_id)

    @user.posted -= 1
    @user.save

    render json: {
      success: @post.errors.count == 0,
      errors: @post.errors.merge!(@user.errors)
    }
  end
end