# Doorkeeper models extensions
People::Application.config.to_prepare do
  Doorkeeper::OAuth::AccessTokenRequest.class_eval { include ResourceableRequest }
  Doorkeeper::AccessToken.class_eval { include Resourceable }
  Doorkeeper::AccessGrant.class_eval { include Resourceable }
  Doorkeeper::Application.class_eval { include Ownable }
end

