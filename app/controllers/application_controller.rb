class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def default_url_options(options={})
    { locale: I18n.locale }
  end

private

  def set_locale
    if params[:locale].present?
      I18n.locale = params[:locale]
    else
      #temporary :en
      I18n.locale = :en 
      #the right instruction : guess from broser or else french
      #I18n.locale = locale_from_accept_language_header || :fr
      redirect_to url_for(locale: I18n.locale)
    end
  end

  def locale_from_accept_language_header
    return nil unless request.env['HTTP_ACCEPT_LANGUAGE'].present?
    parsed_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale  : nil
  end

end
