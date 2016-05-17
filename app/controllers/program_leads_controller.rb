class ProgramLeadsController < ApplicationController
  before_action :section, :offer_params

  def new
    @offer = Offer.data
    @lead = Lead.new
    @lead.offer = params[:offer]
    @lead.version = params[:version]
    render(program_opened? ? 'new' : 'new_closed')
  end

  def create

    @lead = Lead.where(email: lead_params[:email]).first_or_initialize()
    @lead.email = lead_params[:email]
    @lead.first_name = lead_params[:first_name]
    @lead.last_name = lead_params[:last_name]
    @lead.country = lead_params[:country]
    @lead.version = params[:version]
    @lead.offer = params[:offer]

    if program_opened?
      token = params[:stripeToken]
      # Create the charge on Stripe's servers - this will charge the user's card
      begin
        @lead.save!

        charge = Stripe::Charge.create(
          :amount => 10000, # amount in cents, again
          :currency => "eur",
          :source => token,
          :description => @lead.email
        )

        @lead.update_attributes(lead_params.merge(applied_at: Time.now, transaction_number: charge.id))
        JobRunner.run(SendEmail, 'payment_receipt', 'Lead', @lead.id, {'time' => Time.now.to_s})
      rescue  => e
        @payment_error_message = payment_error_message(e)
        JobRunner.run(SendEmail, 'payment_alert', 'Lead', @lead.id, {'time' => Time.now, 'lead_email' => @lead.email, 'error' => e.to_json})
        render :new
        return
      end
    else
      @lead.post_code = lead_params[:post_code]
      saved = @lead.save
      if !saved
        @payment_error_message = "Nous navons pas pu enregistrer vos coordonnées, vérifie votre saisie et essayez de nouveau."
        render new_closed
        return
      end
    end
    flash[:lead] = @lead.id
    redirect_to congratulations_path(version: @chosen_version, offer: @chosen_offer)
  end

  def congrats
    @lead = Lead.find_by_id(flash[:lead])
    render(program_opened? ? 'congrats' : 'congrats_closed')
  end

private

  def section
    @section = :program
  end

  def offer_params
    @chosen_version = params[:version]
    @chosen_offer = params[:offer]
  end


  def lead_params
    params.require(:lead).permit(:email, :first_name, :last_name, :phone, :post_code, :country)
  end

  def program_opened?
    PROGRAM_OPENED
  end

  def payment_error_message error
    unless error.is_a? Stripe::CardError
      return "Une erreur technique est survenue. Votre carte n'a pas été débitée et notre équipe a été prévenue. Vous pouvez essayer de nouveau"
    end
    #here, we know the error is related to the strip charge call, so we have stripe error code for sure
    code = error.json_body[:error][:code]
    res = case code
      when 'incorrect_number' then "Le numéro de la carte est incorrect, vérifiez et essayez de nouveau."
      when 'invalid_number' then "Le numéro de la carte n'est pas un numéro de carte valide"
      when 'invalid_expiry_month' then "Le mois d'expiration n'est pas valide"
      when 'invalid_expiry_year' then "L'année d'expiration n'est pas valide"
      when 'invalid_cvc' then  "Le cryptogramme n'est pas valide, vérifiez et essayez de nouveau."
      when 'expired_card' then "Cette carte a expiré, vous pouvez essayer de nouveau avec une autre carte"
      when 'incorrect_cvc' then "Le cryptogramme n'est pas correct, vérifiez et essayez de nouveau."
      when 'incorrect_zip' then "Le code postal est incorrect"
      when 'card_declined' then "Cette carte a été refusée, vous pouvez essayer de nouveau avec une autre carte"
      when 'missing' then "Carte absente"
      when 'processing_error' then "Une erreur est survenue lors du traitement de la carte. Votre carte n'a pas été débitée, vous pouvez essayer de nouveau"
      when 'rate_limit' then "Une erreur technique est survenue. Votre carte n'a pas été débitée, vous pouvez essayer de nouveau"
      else "Une erreur technique est survenue. Votre carte n'a pas été débitée, vous pouvez essayer de nouveau"
    end
    return res
  end
end