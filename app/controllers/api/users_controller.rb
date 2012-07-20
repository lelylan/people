class Api::UsersController < Api::BaseController
  doorkeeper_for :all

  respond_to :json

  def show
    pp 'SOBO'
    respond_with current_user.as_json(except: :password_digest)
  end
end
