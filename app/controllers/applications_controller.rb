  class ApplicationsController < Doorkeeper::ApplicationController
    respond_to :html

    before_filter :authenticate_resource_owner!
    before_filter :find_applications

    def index
    end

    def new
      @application = Application.new
    end

    def create
      @application = Application.new(params[:application])
      @application.resource_owner_id = current_resource_owner.id.to_s
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
      @applications = Doorkeeper::Application.where(resource_owner_id: current_resource_owner.id)
    end
  end
