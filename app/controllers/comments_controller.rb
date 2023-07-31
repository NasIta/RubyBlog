class CommentsController < ApplicationController
  protect_from_forgery

  def create
    post_data = JSON.parse(request.raw_post)

    user_id = post_data['user_id']
    @user = User.find_by(id: user_id)

    if @user == nil
      raise ActionController::RoutingError.new('User Not Found')
    end

    post_id = post_data['post_id']
    @post = Post.find_by(id: post_id)

    if @post == nil
      raise ActionController::RoutingError.new('Post Not Found')
    end

    @comment = Comment.create(post_data)

    respond_to do |format|
      format.json { render :json => {
        comment: @comment
      } }
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])

    if @comment == nil
      raise ActionController::RoutingError.new('Comment Not Found')
    end

    @comment.delete

    respond_to do |format|
      format.json { render :json => {
        success: @comment.errors.count == 0,
        errors: @comment.errors.full_messages
      } }
    end
  end
end