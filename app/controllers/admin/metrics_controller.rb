class Admin::MetricsController < Admin::BaseController
  def index
    @lead_count   = Lead.count
    @last_5_leads = Lead.last 5
  end
end