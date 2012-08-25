# Public: add and remove the devices and the devices contained in specific locations

class DevicesController < Doorkeeper::ApplicationController
  respond_to :html

  before_filter :authenticate_resource_owner!
  before_filter :find_session
  before_filter :find_resources
  before_filter :find_resource, only: %w(create destroy)

  def index
  end

  def create
    session[:resources][params[:resource_id]] = params
    flash[:notice] = 'One or more devices has been added'
    redirect_to devices_path(authorization_params)
  end

  def destroy
    session[:resources].delete params[:resource_id]
    flash[:notice] = 'One or more devices has been removed'
    redirect_to devices_path(authorization_params)
  end

  private

  def find_session
    session[:resources] ||= {}
  end

  def find_resources
    @devices   = Device.where(resource_owner_id: current_resource_owner.id)
    @locations = Location.where(resource_owner_id: current_resource_owner.id.to_s)
  end

  def find_resource
    id   = params[:resource_id]
    type = params[:resource_type]
    @resource = eval("@#{type.pluralize}.find id")
  end

  def authorization_params
    { response_type: params[:response_type],
      client_id:     params[:client_id],
      redirect_uri:  params[:redirect_uri],
      scope:         params[:scope],
      state:         params[:state] }
  end
end
