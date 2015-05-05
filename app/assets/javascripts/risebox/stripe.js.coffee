rb.initStripe = (formId, stripePublicKey) ->
  Stripe.setPublishableKey(stripePublicKey)
  rb.stripeFormId = formId
  $(formId).submit (event) ->
    $form = $(this)

    #Disable the submit button to prevent repeated clicks
    $form.find('#payment-submit').prop('disabled', true)

    Stripe.card.createToken($form, stripeResponseHandler)

    #Prevent the form from submitting with the default action
    event.preventDefault()

stripeErrorMessage = (code) ->
  res = switch code
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
  return res

stripeResponseHandler = (status, response) ->
  $form = $(rb.stripeFormId)

  if (response.error)
    # Show the errors on the form
    $form.find('._payment-errors').show().text(stripeErrorMessage(response.error.code))
    $form.find('#payment-submit').prop('disabled', false)
  else
    $form.find('._payment-errors').hide()
    # response contains id and card, which contains additional card details
    token = response.id
    # Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token))
    # and submit
    $form.get(0).submit()