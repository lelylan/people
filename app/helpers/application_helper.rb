module ApplicationHelper

  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def dev_host
    "#{request.protocol}#{ENV['LELYLAN_DEV_URL']}:#{ENV['LELYLAN_DEV_PORT']}"
  end

  def title(page_title)
    content_for :title, "Lelylan | #{page_title.to_s}"
  end

  def test_authorization_url(application)
    authorization_params = {
      response_type: 'code',
      client_id:     application.uid,
      redirect_uri:  application.redirect_uri,
      scope:         'resources',
      state:         'remember-me' }
    oauth_authorization_path(authorization_params)
  end

  def lelylan_error_messages_for(resource)
    return '' if resource.errors.empty?
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
    html = <<-HTML
    <div class="errors">
      <div id="error_explanation">
        <h2>#{sentence}</h2>
        <ul>#{messages}</ul>
      </div>
    </div>
    HTML

    html.html_safe
  end
end
