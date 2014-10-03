class Lead < ActiveRecord::Base
  validates_presence_of   :email, message: 'we need a valid email, please try again'
  validates_format_of     :email, message: 'we need a valid email, please try again', :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates_uniqueness_of :email, message: 'you already subscribed, thank you'
end
