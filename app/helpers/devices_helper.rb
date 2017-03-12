module DevicesHelper
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
      accessible_type: 'device'
    )
  end

end
