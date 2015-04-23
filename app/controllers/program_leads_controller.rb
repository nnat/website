class ProgramLeadsController < ApplicationController
  before_action :section

  def new
    @lead = Lead.new
  end

  def create
    puts "in create lead_params[:email] #{lead_params[:email]} lead_params #{lead_params}"

    @lead = Lead.where(email: lead_params[:email]).first_or_initialize()
    if @lead.update_attributes(lead_params.merge(applied_at: Time.now))
      redirect_to congratulations_path
    else
      flash[:alert] = "Désolé votre réservation n'a pas été enregistrée. Envoyer-nous un email"
    end
  end

private

  def section
    @section = :program
  end


  def lead_params
    params.require(:lead).permit(:email, :first_name, :last_name, :post_code)
  end
end