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

  def device_params
    authorization_params.merge(type: 'devices')
  end

  def location_params
    authorization_params.merge(type: 'locations')
  end
end
