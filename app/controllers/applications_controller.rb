# Override Doorkeeper::ApplicationsController.
#
# This action is called when the resource owner wants to access its applications.
# This change has been added as we do want let the user create its own applications
# and he must be the only one to access them.
#
# Doorkeeper offers the ability to admin users to access to this area but we do 
# not want this. We want an application section where an admin can have access to
# all resources and where th resource owner has access to his own applications.

class ApplicationsController < Doorkeeper::ApplicationController
  respond_to :html

  before_filter :authenticate_resource_owner!
  before_filter :find_applications

  def index
  end

  def new
    @application = Doorkeeper::Application.new
  end

  def create
    @application = Doorkeeper::Application.new(params[:application])
    @application.resource_owner_id = current_resource_owner.id
    if @application.save
      flash[:notice] = "Application created"
      respond_with [:oauth, @application]
    else
      render :new
    end
  end

  def show
    @application = @applications.find(params[:id])
  end

  def edit
    @application = @applications.find(params[:id])
  end

  def update
    @application = @applications.find(params[:id])
    if @application.update_attributes(params[:application])
      flash[:notice] = "Application updated"
      respond_with [:oauth, @application]
    else
      render :edit
    end
  end

  def destroy
    @application = @applications.find(params[:id])
    flash[:notice] = "Application deleted" if @application.destroy
    redirect_to oauth_applications_url
  end

  private

  def find_applications
    @applications = if current_resource_owner.admin?
                      Doorkeeper::Application.all
                    else
                      Doorkeeper::Application.where(resource_owner_id: current_resource_owner.id)
                    end
  end
end
