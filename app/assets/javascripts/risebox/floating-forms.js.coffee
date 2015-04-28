rb.decorateFloatingForms = ->
  floatingForm = $('._floatingForm')
  formBottom = floatingForm.offset().top + floatingForm.height()
  screenHeight = (window.innerHeight|| document.documentElement.clientHeight|| document.getElementsByTagName('body')[0].clientHeight)
  if screenHeight <= formBottom
  	bottomSpace = 0
  else
    bottomSpace = screenHeight - formBottom
  floatingForm.css "bottom", "#{bottomSpace}px"

  $(window).scroll () =>
    scroll = $(window).scrollTop() + screenHeight
    console.log "scroll : #{scroll}   formBottom : #{formBottom}"
    if scroll > (formBottom + bottomSpace)
      floatingForm.addClass('affix')
      floatingForm.removeClass('affix-top')
    else
      floatingForm.addClass('affix-top')
      floatingForm.removeClass('affix')