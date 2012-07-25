class AuthorizationsController < Doorkeeper::AuthorizationsController

  # TODO find a better way to understand if its for grant or token
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
    for_grant? ? find_grant.save_resources(resources) : find_token.save_resources(resources)
  end

  def find_token
    for_token?
  end

  def find_grant
    for_grant?
  end

  # Authorization code flow (creates an access grant)
  def for_token?
    app = authorization.instance_variable_get '@authorization'
    app.instance_variable_get '@access_token'
  end

  # Implicit authorization flow (creates an access token)
  def for_grant?
    app = authorization.instance_variable_get '@authorization'
    app.respond_to?('grant') ? app.grant : nil
  end
end

