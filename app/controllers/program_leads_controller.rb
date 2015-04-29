class ProgramLeadsController < ApplicationController
  before_action :section

  def new
    @lead = Lead.new
  end

  def create
    puts "in create lead_params[:email] #{lead_params[:email]} lead_params #{lead_params}"

    @lead = Lead.where(email: lead_params[:email]).first_or_initialize()

    token = params[:stripeToken]

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => 10000, # amount in cents, again
        :currency => "eur",
        :source => token,
        :description => @lead.email
      )


    rescue Stripe::CardError => e
      # JobRunner.run(SendEmail, 'payment_alert', 'Lead', @lead.id)
      flash.now[:alert] = "Désolé la transaction n'a pas pu aboutir. Envoyez-nous un email"
      render :new
      return
    end

    @lead.update_attributes(lead_params.merge(applied_at: Time.now))
    redirect_to congratulations_path

  end

private

  def section
    @section = :program
  end


  def lead_params
    params.require(:lead).permit(:email, :first_name, :last_name, :post_code)
  end
end