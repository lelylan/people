class UsersController < ApplicationController
  doorkeeper_for :all

  respond_to :json

  def me
    respond_with current_user.as_json(except: :password_digest)
  end
end
