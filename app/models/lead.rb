class Lead < ActiveRecord::Base
  validates_presence_of   :email, message: I18n.t('lead.validation.presence')
  validates_format_of     :email, message: I18n.t('lead.validation.format'), with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_uniqueness_of :email, message: I18n.t('lead.validation.uniqueness')
end
