# Doorkeeper models extensions
People::Application.config.to_prepare do
  Doorkeeper::AccessToken.class_eval { include Resourceable }
  Doorkeeper::AccessGrant.class_eval { include Resourceable }
  Doorkeeper::Application.class_eval { include Ownable }
  Doorkeeper::OAuth::AccessTokenRequest.class_eval { include ResourceableRequest }
end

