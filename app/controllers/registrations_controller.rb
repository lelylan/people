# Override Devise::RegistrationsController
#
# * .edit_password lets us register a user without password confirmation
# * .after_update_path_for lets us redirect where we want.

class RegistrationsController < Devise::RegistrationsController
  def edit_password
    build_resource
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
