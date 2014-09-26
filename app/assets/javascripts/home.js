$(document).ready ->

  $(document).bind "ajaxSuccess", "form._leadForm'", (event, xhr, settings) ->
    $('#leadSuccess').text('Youhou you are registered').show()
    // $thing_form = $(event.data)
    // $error_container = $("#error_explanation", $thing_form)
    // $error_container_ul = $("ul", $error_container)
    // $("<p>").html(xhr.responseJSON.title + " saved.").appendTo $thing_form
    // if $("li", $error_container_ul).length
    //   $("li", $error_container_ul).remove()
    //   $error_container.hide()

  $(document).bind "ajaxError", "form.thing_form", (event, jqxhr, settings, exception) ->
    $('#leadError').text('problem error').show()
    // $thing_form = $(event.data)
    // $error_container = $("#error_explanation", $thing_form)
    // $error_container_ul = $("ul", $error_container)
    // $error_container.show()  if $error_container.is(":hidden")
    // $.each jqxhr.responseJSON, (index, message) ->
    //   $("<li>").html(message).appendTo $error_container_ul