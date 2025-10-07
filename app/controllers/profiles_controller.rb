class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def destroy
    if params[:confirm_email] == current_user.email
      current_user.destroy
      redirect_to root_path, notice: "Your account has been deleted successfully."
    else
      redirect_to profile_path, alert: "Email confirmation did not match. Account not deleted."
    end
  end
end
