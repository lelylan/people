class SubscriptionsController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!, only: :index
  before_filter :admin?, only: :index

  def index
    @registered_emails = User.all.map(&:email)
    pp @registered_emails
    @subscriptions = Subscription.where(later: false)
  end

  def show
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save
      flash[:notice] = 'Thank you for your interest in Lelylan'
      redirect_to subscription_path @subscription if not current_user.admin
      redirect_to subscriptions_path @subscription if current_user.admin
    else
      render :new
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    flash[:notice] = 'Subscription deleted' if @subscription.destroy
    redirect_to subscriptions_url
  end

  def invite
    User.invite! email: params[:email]
    flash[:notice] = "The user #{params[:email]} has been successfully invited"
    redirect_to subscriptions_path
  end

  def see_later
    @subscriptions = Subscription.where(later: true)
    render :index
  end

  def later
    user = Subscription.where(email: params[:email]).first
    user.update_attributes(later: true)
    flash[:notice] = "The user #{params[:email]} has been successfully moved later"
    redirect_to subscriptions_path
  end

  def prioritize
    user = Subscription.where(email: params[:email]).first
    user.update_attributes(later: false)
    flash[:notice] = "The user #{params[:email]} has been successfully prioritized"
    redirect_to see_later_subscriptions_path
  end

  private

  def admin?
    if not current_user.admin
      flash[:notice] = "You can't access this page"
      redirect_to root_path
    end
  end
end
