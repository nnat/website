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
      @payment_error = e.to_json
      @payment_error_message = payment_error_message(e)
      JobRunner.run(SendEmail, 'payment_alert', 'Lead', @lead.id)
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

  def payment_error_message stripe_error
    code = stripe_error.json_body[:error][:code]
    res = case code
      when 'incorrect_number' then "Le numéro de la carte est incorrect"
      when 'invalid_number' then "Le numéro de la carte n'est pas un numéro de carte valide"
      when 'invalid_expiry_month' then "Le mois d'expiration n'est pas valide"
      when 'invalid_expiry_year' then "L'année d'expiration n'est pas valide"
      when 'invalid_cvc' then  "Le cryptogramme n'est pas valide"
      when 'expired_card' then "Cette carte a expirée, vous pouvez essayer de nouveau avec une autre carte"
      when 'incorrect_cvc' then "Le cryptogramme n'est pas correct"
      when 'incorrect_zip' then "Le zip code est incorrect"
      when 'card_declined' then "Cette carte a été refusée, vous pouvez essayer de nouveau avec une autre carte"
      when 'missing' then "Carte absente"
      when 'processing_error' then "Une erreur est survenue lors du traitement de la carte. Votre carte n'a pas été débitée, vous pouvez essayer de nouveau"
      when 'rate_limit' then "Une erreur technique est survenue. Votre carte n'a pas été débitée, vous pouvez essayer de nouveau"
      else "Une erreur technique est survenue. Votre carte n'a pas été débitée, vous pouve essayer de nouveau"
    end
    return res
  end
end