class PostsController < ApplicationController
  protect_from_forgery

  def create
    respond_to do |format|
      format.json { render :json => {
        post: "aSSDADASD"
      } }
    end
  end

  def update

  end

  def delete

  end
end