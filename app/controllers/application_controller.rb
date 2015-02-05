class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :restrict_access, :set_locale

private

  def set_locale
    unless Rails.env.test?
      I18n.locale = params[:locale] || locale_from_accept_language_header || I18n.default_locale
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

end