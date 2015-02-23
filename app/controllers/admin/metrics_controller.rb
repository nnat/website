class Admin::MetricsController < Admin::BaseController
  def index
    @lead_count   = Lead.count
    @last_leads = Lead.last(params[:nb] || 5)
  end
end