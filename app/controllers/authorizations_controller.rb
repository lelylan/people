# Override Doorkeeper::AuthorizationsController. 
#
# This action is called when the resource owner grant the access to its resources. 
#
# This means that it can be called during two flows:
# - authorization code: in this case an authorization code is issued
# - implicit grant: in this case an access token is issued
#
# The override of the controller comes out because we need to save also the 
# list of devices and we must do it from the controller as they are saved in 
# session. Wht we do is to check into the 'authorization request' object and 
# add the additional information. 
#
# Depending from the flow it's being used we add the list of devices to:
# - AccessGrant during the authorization code flow
# - AccessToken during the implicit grant flow

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
    token = access_grant ? access_grant : access_token
    pp resources.map(&:first).map(&:last)
    token.update_attributes(resources: resources.map(&:first).map(&:last))
    session[:resources] = nil
  end

  # Authorization code flow (creates an access grant)
  def access_token
    app = authorization.instance_variable_get '@authorization'
    app.instance_variable_get '@access_token'
  end

  # Implicit authorization flow (creates an access token)
  def access_grant
    app = authorization.instance_variable_get '@authorization'
    app.respond_to?('grant') ? app.grant : nil
  end
end

