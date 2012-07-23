Doorkeeper.configure do
  # ORM setting. Currently supported options are :active_record and :mongoid
  orm :mongoid

  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do |routes|
    current_user || warden.authenticate!(:scope => :user)
  end

  # Tell doorkeeper how to authenticate the resource owner with username/password
  resource_owner_from_credentials do |routes|
    User.authenticate!(params[:username], params[:password])
  end

  # If you want to restrict access to the web interface for adding oauth authorized applications
  # you need to declare the block below.
  admin_authenticator do |routes|
    # Admin.find_by_id(session[:admin_id]) || redirect_to(routes.new_admin_session_url)
    current_user || warden.authenticate!(:scope => :user) || redirect_to(root_path)
  end

  # Authorization Code expiration time (default 10 minutes).
  # authorization_code_expires_in 10.minutes

  # Access token expiration time (default 2 hours).
  # If you want to disable expiration, set this to nil.
  # access_token_expires_in 2.hours

  # Issue access tokens with refresh token (disabled by default)
  use_refresh_token

  # Define access token scopes for your provider
  # For more information go to https://github.com/applicake/doorkeeper/wiki/Using-Scopes
  default_scopes  :public
  optional_scopes :write

  # Change the way client credentials are retrieved from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:client_id` and `:client_secret` params from the `params` object.
  # Check out the wiki for more information on customization
  # client_credentials :from_basic, :from_params

  # Change the way access token is authenticated from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:access_token` or `:bearer_token` params from the `params` object.
  # Check out the wiki for mor information on customization
  # access_token_methods :from_bearer_authorization, :from_access_token_param, :from_bearer_param
end
