class Admin::MetricsController < Admin::BaseController
  def index
    @lead_count    = Lead.count
    @nb_last_leads = params[:nb].present? ? params[:nb].to_i : 5
    @last_leads    = Lead.last(@nb_last_leads)
    @paying_leads  = Lead.applied_recently
  end
end