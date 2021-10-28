class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute :activated_at, Time.zone.now
      flash[:success] = t "account_activated"
      redirect_to login_url
    else
      flash[:danger] = t "invalid_activation_link"
      redirect_to root_url
    end
  end
end
