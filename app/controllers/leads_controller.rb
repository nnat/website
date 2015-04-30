class LeadsController < ApplicationController
  def create
    @lead = Lead.new(lead_params)
    @lead_saved = @lead.save
  end

  def update
    @lead = Lead.find(params[:id])
    @updated = @lead.update_attributes(lead_params)
    render 'update'
  end

  private

  def lead_params
    params.require(:lead).permit(:email, :phone)
  end
end