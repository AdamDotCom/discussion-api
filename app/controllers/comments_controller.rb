class CommentsController < ApplicationController
  def index
    respond_with(Comment.all)
  end

  def create
    comment = params.require(:comment).permit!
    post = params.fetch(:post, {}).permit!
    user = params.fetch(:user, {}).permit!

    @user = User.find(params[:user_id] || user[:id])
    @post = Post.find(params[:post_id] || post[:id])

    @comment = @post.comments.create(comment.merge({ user: @user }))

    respond_with(@comment)
  end

  def show
    respond_with(Comment.find(params[:id]))
  end
end
