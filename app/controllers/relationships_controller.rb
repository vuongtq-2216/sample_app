class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = @user_relationship.followed
    current_user.unfollow @user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t ".not_found_user"
    redirect_to root_url
  end

  def load_relationship
    @user_relationship = Relationship.find_by id: params[:id]
    return if @user_relationship

    flash[:danger] = t ".not_found_user"
    redirect_to root_url
  end
end
