class CommentsController < ApplicationController
  protect_from_forgery

  def create
    @comment = Comment.new(comment_create_params)
    @comment.save

    render json: {
      comment: @comment,
      errors: @comment.errors
    }
  end

  def comment_create_params
    params.require(:comment).permit(:post_id, :user_id, :rate, :text)
  end

  def destroy
    @comment = Comment.find_by!(id: params[:id])

    @comment.delete

    render json: {
      success: @comment.errors.count == 0,
      errors: @comment.errors
    }
  end
end