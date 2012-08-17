class Api::UsersController < Api::BaseController
  doorkeeper_for :show, scopes: %w(user resources)

  respond_to :json

  def show
    respond_with current_user.as_json(except: :password_digest)
  end
end
