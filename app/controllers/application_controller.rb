class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout :layout_by_resource

  private
  def layout_by_resource
    if controller_name == "landing"
      "landing"
    elsif devise_controller?
      # return "auth" if new_user_session GET    /users/sign_in(.:format) devise/sessions#new,  new_user_registration GET    /users/sign_up(.:format) devise/registrations#new, passwords#new, confirmations#new
      "auth_layout" if (controller_name == "sessions" && action_name == "new") || (controller_name == "registrations" && action_name == "new") || (controller_name == "passwords" && action_name == "new") || (controller_name == "confirmations" && action_name == "new")
    else
      "application"
    end
  end
end
