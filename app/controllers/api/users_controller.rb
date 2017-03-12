class Api::UsersController < Api::BaseController
  doorkeeper_for :show, scopes: Settings.scopes.read.map(&:to_sym)

  respond_to :json

  # TODO Move to invitation system and use proper system to serialize
  def show
    result = {
     id: current_user._id,
     email: current_user.email,
     full_name: current_user.full_name,
     homepage: current_user.full_name,
     rate_limit: current_user.rate_limit }

    respond_with result
  end
end
