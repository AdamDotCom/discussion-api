class UsersController < ApplicationController
  def index
    respond_with(User.all)
  end

  def create
    user = params.require(:user).permit!

    @user = User.create(user)

    respond_with(@user)
  end
end
