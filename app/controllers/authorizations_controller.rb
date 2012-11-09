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
# session. What we do is to check into the 'authorization request' object and
# add the additional information.
#
# Depending from the flow it's being used we add the list of devices to:
# - AccessGrant during the authorization code flow
# - AccessToken during the implicit grant flow

class AuthorizationsController < Doorkeeper::AuthorizationsController

  def create
    auth = authorization.authorize

    if auth.redirectable?
      save_expirable(auth)
      save_resources(auth, session[:resources]) if session[:resources]
      redirect_to auth.redirect_uri
    else
      render :json => auth.body, :status => auth.status
    end
  end

  private

  def save_expirable(auth)
    auth.auth.token.update_attributes!(expires_in: nil) unless params[:expirable]
  end

  def save_resources(auth, resources = {})
    auth.auth.token.update_attributes!(resources: resources.values)
    session[:resources] = nil
  end
end

