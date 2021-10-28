class UsersController < ApplicationController
  before_action :logged_in, only: %i(index edit update destroy)
  before_action :same_user, only: %i(edit update)
  before_action :admin_logged_in, :not_same_user, only: :destroy
  include SessionsHelper

  def index
    @users = User.order_by_name(:ASC).paginate(page: params[:page],
                          per_page: Settings.will_pagination.per_page_10)
  end

  def edit
    load_user_or_redirect
  end

  def show
    load_user_or_redirect
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = t "user_created_html", username: @user.name
      flash[:warning] = t "please_activate_account"
      redirect_to login_url
    else
      render :new
    end
  end

  def update
    load_user_or_redirect
    if update_success?
      flash[:success] = t "user_updated_html", username: @user.name
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    load_user_or_redirect
    if @user&.destroy
      flash[:success] = t "user_deleted_html", username: @user.name
    else
      flash[:warning] = t "user_deletion_failed_html", username: @user.name
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in
    return if logged_in?

    save_back_url
    flash[:danger] = t "login_first"
    redirect_to login_url
  end

  def load_user_or_redirect
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t "user_not_found"
    redirect_to users_url
  end

  def update_success?
    params = user_params
    @user.update_attribute(:name, params[:name]) &&
      @user.update_attribute(:email, params[:email])
  end

  def same_user
    load_user_or_redirect
    return if @user == current_user

    flash[:danger] = t "must_same_user_html", username: @user.name
    redirect_to users_url
  end

  def not_same_user
    load_user_or_redirect
    return unless @user == current_user

    flash[:danger] = t "can_not_delete_self"
    redirect_to users_url
  end

  def admin_logged_in
    return if current_user.is_admin

    flash[:danger] = t "must_be_admin"
    redirect_to users_url
  end
end
