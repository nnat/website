class UserMailer < ActionMailer::Base
  require 'email_header.rb'

  # default "notification@risebox.co"
  layout 'mailer'

  def device_alert metric_status
    headers['X-SMTPAPI'] = single_recipient_header 'device_alert'
    @metric_status = metric_status
    @metric        = metric_status.metric
    @user          = metric_status.device.owner
    mail(to: @user.email, subject: "Risebox - Alerte sur votre device")
  end

private

  def single_recipient_header category, bypass_list_management=false
    hd = EmailHeader.new(nil, category, nil)
    hd.add_filter_setting('bypass_list_management', 'enable', 1) if bypass_list_management
    hd.as_json
  end
end