class UsersController < ApplicationController
  include SessionLogic

  def new
    @user = User.new
  end

  # POST /users or /users.json
  def login
    @user = User.find_by_email(user_params[:email])

    if @user
      session_login(@user.id)
      redirect_to appointments_url, notice: I18n.t('user_was_successfully_logged_in')
    else
      redirect_to login_url, notice: I18n.t('the_entered_user_has_no_appointments_with_us')
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
