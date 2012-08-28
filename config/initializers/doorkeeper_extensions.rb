# Doorkeeper models extensions
People::Application.config.to_prepare do
  Doorkeeper::AccessToken.class_eval { include Accessible }
  Doorkeeper::AccessGrant.class_eval { include Accessible }
  Doorkeeper::Application.class_eval { include Ownable }
  Doorkeeper::OAuth::AccessTokenRequest.class_eval { include AccessibleRequest }
end
