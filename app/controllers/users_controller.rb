class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: I18n.t('user_was_successfully_created') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def login
    @user = User.find_by_email(user_params[:email])

    if @user
      session[:current_user_id] = @user.id
      redirect_to appointments_url, notice: I18n.t('user_was_successfully_logged_in')
    else
      redirect_to login_url, notice: I18n.t('the_entered_user_has_no_appointments_with_us')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
