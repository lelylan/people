class AuthorizationsController < Doorkeeper::AuthorizationsController

  def create
    if authorization.authorize
      save_resources(authorization, session[:resources])
      redirect_to authorization.success_redirect_uri
    elsif authorization.redirect_on_error?
      redirect_to authorization.invalid_redirect_uri
    else
      @error = authorization.error_response
      render :error
    end
  end

  private

  def save_resources(authorization, resources)
    authorization = authorization.instance_variable_get '@authorization'
    authorization.grant.save_resources resources
  end
end

