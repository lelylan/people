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

  def authorization_params
    {
      response_type: params[:response_type],
      client_id:     params[:client_id],
      redirect_uri:  params[:redirect_uri],
      scope:         params[:scope],
      state:         params[:state]
    }
  end

  def device_params(device)
    authorization_params.merge(
      resource_id: device.id,
      resource_type: 'device',
      filtered_type: 'device'
    )
  end

  def location_params(location)
    authorization_params.merge(
      resource_id: location.id,
      resource_type: 'location',
      filtered_type: 'device'
    )
  end
end
