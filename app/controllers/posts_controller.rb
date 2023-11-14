class PostsController < ApplicationController
  def index
    respond_with(Post.all)
  end
end
