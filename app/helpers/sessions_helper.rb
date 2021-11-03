module SessionsHelper
  def log_in user, remember_me
    # saves user id to client's session cookie
    session[:user_id] = user.id
    remember user if remember_me == "1"
  end

  def remember user
    user.remember_me
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent.signed[:user_id] = user.id
  end

  def current_user
    # gets current user info
    # @current_user ||= User.find_by id: session[:user_id]
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated?(cookies[:remember_token])
        log_in user, false
        @current_user = user
      end
    end
  end

  def logged_in?
    # shorthand for checking if current user is present
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    cookies.delete :user_id if cookies.signed[:user_id]
    @current_user = nil
  end

  def save_back_url
    session[:back_url] = request.original_url if request.get?
  end

  def redirect_back_or default
    redirect_to session[:back_url] || default
    session.delete :back_url
  end
end
