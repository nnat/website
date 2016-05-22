class ApplicationController < ActionController::Base
  include UserFilteringHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :restrict_access, :set_locale, :set_origin_token

private

  def set_locale
    unless Rails.env.test?
      I18n.locale = I18n.default_locale
      #I18n.locale = params[:locale] || locale_from_accept_language_header || I18n.default_locale
    end
  end

  def default_url_options(options={})
    { locale: I18n.locale }
  end

  def locale_from_accept_language_header
    return nil unless request.env['HTTP_ACCEPT_LANGUAGE'].present?
    parsed_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale  : nil
  end

  def set_origin_token
    if params[:utm_source].present? && params[:utm_campaign].present? && params[:utm_content].present?
      concat_token = params[:utm_source] + '_' + params[:utm_campaign] + '_' + params[:utm_content]
      cookies[:origin_token] = { :value => concat_token, :expires => 30.days.from_now }
    end
  end

end