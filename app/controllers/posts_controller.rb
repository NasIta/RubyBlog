class PostsController < ApplicationController
  protect_from_forgery

  def create
    posts_service = PostsService.new
    @post = posts_service.create(post_create_params)

    render json: {
      post: @post,
      errors: @post.errors
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
    posts_service = PostsService.new
    @post = posts_service.destroy_by_id(params[:id])

    render json: {
      success: @post.errors.count == 0,
      errors: @post.errors
    }
  end
end