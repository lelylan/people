class ResourcesController < Doorkeeper::ApplicationController
  respond_to :html

  before_filter :authenticate_resource_owner!
  before_filter :find_session
  before_filter :find_type, only: %w(update destroy)
  before_filter :find_resources
  before_filter :find_resource, only: %(update destroy)

  def index
  end

  def update
    session[:resources][@type].push(@resource.id).uniq!
    flash[:notice] = "#{@type.humanize} added"
    redirect_to resources_uri(authorization_params)
  end

  def destroy
    session[:resources][type].delete(@resource.id)
    flash[:notice] = "#{type.humanize} added"
    redirect_to resources_uri(authorization_params)
  end

  private

  def find_session
    session[:resources] ||= { devices: [], locations: [] }
  end

  def find_type
    @type = params[:type]
  end

  def find_resources
    @devices   = Device.where(resource_owner_id: current_resource_owner.id)
    @locations = Location.where(resource_owner_id: current_resource_owner.id.to_s)
  end

  def find_resource
    @resource = (@type == 'devices') ? @devices.find(params[:id]) : @locations.find(params[:id])
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
end
