class CommentsController < ApplicationController
  def index
    respond_with(Comment.all)
  end
end
