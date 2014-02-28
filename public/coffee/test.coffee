l = new Loader()
l.require [
  "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"
], ->
  
  # Callback
  $('.tok3n-submit').click(->
    setTimeout (->
      # Card flip
        $('.tok3n-flipper').toggleClass('tok3n-flipped')
        $('.tok3n-back').css('z-index', '3')
        return
    ), 500
    return
  )
  $('.tok3n-header').click(->
    # $this = $(this)
    # if $this 
    $('.tok3n-login-alert').removeClass('tok3n-login-alert-hidden').addClass('tok3n-login-alert-active')
    return
  )

  return