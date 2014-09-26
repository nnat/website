class LeadsController < ApplicationController
  def create
    puts "before #{params}"
    @lead = Lead.new(lead_params)
    redirect_to(root_path) unless @lead.save
  end

  private

  def lead_params
    params.require(:lead).permit(:email)
  end
end