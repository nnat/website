rb.decorateFloatingForms = ->
  # $('._floatingForm').affix()
  formTop = $('._floatingForm').offset().top
  $(window).scroll () ->
    scroll = $(window).scrollTop()
    if (scroll > formTop)
      $('._floatingForm' ).addClass('affix')
    else
      $('._floatingForm' ).addClass('affix-top')