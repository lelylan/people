class RegistrationsController < Devise::RegistrationsController

  def change
    build_resource
  end

end
