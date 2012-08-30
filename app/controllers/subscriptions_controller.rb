class SubscriptionsController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!, only: :index
  before_filter :admin?, only: :index

  def index
    @subscriptions = Subscription.nin(email: User.all.map(&:email))
  end

  def show
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save
      flash[:notice] = 'Subscription created'
      redirect_to subscription_path @subscription
    else
      render :new
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    flash[:notice] = "Subscription deleted" if @subscription.destroy
    redirect_to subscriptions_url
  end

  def invite
    User.invite! email: params[:email]
    flash[:notice] = "The user #{params[:email]} has been invited"
    redirect_to subscriptions_path
  end

  private

  def admin?
    if not current_user.admin
      flash[:notice] = "You can't access this page"
      redirect_to root_path
    end
  end
end
