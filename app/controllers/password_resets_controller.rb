class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration, only: %i(edit update)
  before_action :load_user_create, only: :create

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t ".sent_mail_reset"
    redirect_to root_url
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t(".not_empty_pass"))
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".pass_reset_ok"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.show.not_found_user"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".pass_expired"
    redirect_to new_password_reset_path
  end

  def load_user_create
    @user = User.find_by email: params[:password_reset][:email].downcase
    return if @user

    flash.now[:danger] = t ".not_found"
    render :new
  end
end
