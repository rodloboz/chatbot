class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      if params.dig(:user, :account_linking_token).present?
        url = params.dig(:user, :redirect_uri) + "&authorization_code=#{resource.authentication_token}"
        redirect_to url
      else
        respond_with resource, :location => after_sign_in_path_for(resource)
      end
    end
  end
end
