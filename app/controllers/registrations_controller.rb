class RegistrationsController < Devise::RegistrationsController

  def edit_password
    build_resource
  end

  protected

    def after_update_path_for(resource)
      edit_user_registration_path(resource)
    end
end
