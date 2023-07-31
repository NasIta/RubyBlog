class PostsController < ApplicationController
  protect_from_forgery

  def create
    post_data = JSON.parse(request.raw_post)

    user_id = post_data['user_id']
    @user = User.find_by(id: user_id)

    if @user == nil
      raise ActionController::RoutingError.new('Not Found')
    end

    @post = Post.create(
      title: post_data['title'],
      text: post_data['text'],
      user_id: user_id,
    )

    @post.save

    @user.posted += 1
    @user.save

    respond_to do |format|
      format.json { render :json => {
        post: @post,
        errors: @post.errors
      } }
    end
  end

  def update
    post_data = JSON.parse(request.raw_post)

    @post = Post.find_by(id: params[:id])

    if @post == nil
      raise ActionController::RoutingError.new('Post Not Found')
    end

    @post.title = post_data['title']
    @post.text = post_data['text']
    @post.save

    respond_to do |format|
      format.json { render :json => {
        post: @post,
        errors: @post.errors
      } }
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])

    if @post == nil
      raise ActionController::RoutingError.new('Post Not Found')
    end

    @post.delete_children
    @post.delete

    @user = User.find_by(id: @post.user_id)
    if @user == nil
      raise ActionController::RoutingError.new('User Not Found')
    end

    @user.posted -= 1
    @user.save

    respond_to do |format|
      format.json { render :json => {
        success: @post.errors.count == 0,
        errors: @post.errors.full_messages
      } }
    end
  end
end