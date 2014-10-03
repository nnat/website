class LeadsController < ApplicationController
  def create
    puts "before #{params}"
    @lead = Lead.new(lead_params)
    @lead_saved = @lead.save
  end

  private

  def lead_params
    params.require(:lead).permit(:email)
  end
end