rb.initStripe = (formId, stripePublicKey) ->
  Stripe.setPublishableKey(stripePublicKey);
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
    when 'incorrect_number' then "Le numéro de la carte est incorrect"
    when 'invalid_number' then "Le numéro de la carte n'est pas un numéro de carte valide"
    when 'invalid_expiry_month' then "Le mois d'expiration n'est pas valide"
    when 'invalid_expiry_year' then "L'année d'expiration n'est pas valide"
    when 'invalid_cvc' then  "Le cryptogramme n'est pas valide"
    when 'expired_card' then "La carte a expirée"
    when 'incorrect_cvc' then "Le cryptogramme n'est pas correct"
    when 'incorrect_zip' then "Le zip code est incorrect"
    when 'card_declined' then "La carte a été déclinée"
    when 'missing' then "Il n'y a pas de carte pour cet l'utilisateur"
    when 'processing_error' then "Une erreur est survenue lors du traitement de la carte"
    when 'rate_limit' then "Une erreur est survenue car trop de requêtes ont été réalisées"
    else "Erreur inconnue"
  return res

stripeResponseHandler = (status, response) ->
  $form = $(rb.stripeFormId)

  if (response.error)
    # Show the errors on the form
    $form.find('.payment-errors').text(stripeErrorMessage(response.error.type));
    $form.find('#payment-submit').prop('disabled', false);
  else
    # response contains id and card, which contains additional card details
    token = response.id
    # Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    # and submit
    $form.get(0).submit()