module ApplicationHelper

  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def dev_host
    "#{request.protocol}#{ENV['LELYLAN_DEV_URL']}:#{ENV['LELYLAN_DEV_PORT']}"
  end
end
