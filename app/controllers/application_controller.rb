class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout :layout_by_resource

  private
  def layout_by_resource
    if controller_name == "landing"
      "landing"
    elsif devise_controller?
      "auth_layout"
    else
      "application"
    end
  end

  # Devise: redirect users to workout plans after sign in/out
  def after_sign_in_path_for(resource)
    workout_plans_path
  end

  def after_sign_out_path_for(resource_or_scope)
    # signin page
    new_user_session_path
  end
end
