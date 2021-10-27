class UsersController < ApplicationController
  def show
    # @user = User.find(params[:id])
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:warning] = t "user_not_found"
    redirect_to login_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "welcome_logged_in_message_html", username: @user.name
      redirect_to @user
    else
      render :new
    end
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
