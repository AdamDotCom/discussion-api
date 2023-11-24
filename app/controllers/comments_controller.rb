class CommentsController < ApplicationController
  def index
    @post = Post.find(params[:post_id]) if params.key?(:post_id)
    @user = User.find(params[:user_id]) if params.key?(:user_id)

    @comments = if @post
                  @post.comments
                elsif @user
                  Comment.where({ user: @user })
                else
                  Comment.all
                end


    respond_with(@comments)
  end

  def create
    comment = params.require(:comment).permit!
    post = params.fetch(:post, {}).permit!
    user = params.fetch(:user, {}).permit!

    @user = User.find(params[:user_id] || user[:id])
    @post = if comment[:comment_id]
              Comment.find(comment[:comment_id]).post
            else
              Post.find(params[:post_id] || post[:id])
            end

    @comment = @post.comments.create(comment.merge({ user: @user }))

    respond_with(@comment)
  end

  def show
    respond_with(Comment.find(params[:id]))
  end
end
