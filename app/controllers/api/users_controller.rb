class Api::UsersController < Api::BaseController
  doorkeeper_for :show, scopes: %w(user resources-read resources).map(&:to_sym)

  respond_to :json

  # TODO Move to invitation system and use proper system to serialize
  def show
    result = {
     id: current_user._id,
     email: current_user.email,
     full_name: current_user.full_name,
     homepage: current_user.full_name,
     location: current_user.full_name,
     rate_limit: current_user.rate_limit }

    respond_with result
  end
end
