# Doorkeeper models extensions
People::Application.config.to_prepare do
  Doorkeeper::AccessToken.class_eval { include Accessible; include Expirable; include Indexable }
  Doorkeeper::AccessGrant.class_eval { include Accessible; include Expirable }
  Doorkeeper::Application.class_eval { include Ownable }
  Doorkeeper::OAuth::AccessTokenRequest.class_eval { include AccessibleRequest }
end
