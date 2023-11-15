class PostsController < ApplicationController
  def index
    respond_with(Post.all)
  end

  def create
    post = params.require(:post).permit!
    user = params.require(:user).permit!

    @user = User.find(user[:id])
    @post = Post.create(post.merge({ user: @user }))

    respond_with(@post)
  end

  def show
    respond_with(Post.find(params[:id]))
  end

  def comments
    respond_with(Post.find(params[:id]).comments)
  end
end
