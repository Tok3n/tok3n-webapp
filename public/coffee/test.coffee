l = new Loader()
l.require [
  "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"
], (->
  
  # Callback
  $('.tok3n-submit').click(->
    setTimeout (->
      # Card flip
        $('.tok3n-flipper').toggleClass('tok3n-flipped')
        $('.tok3n-back').css('z-index', '999')
        return
    ), 500
    return
  )
  $('.tok3n-header').click(->
    alertElem = $('.tok3n-login-alert')
    if alertElem.hasClass('tok3n-login-alert-active')
      alertElem.removeClass('tok3n-login-alert-active')
      setTimeout(-> alertElem.addClass('tok3n-login-alert-active'), 0)
    else
      alertElem.removeClass('tok3n-login-alert-hidden').addClass('tok3n-login-alert-active')
    return
  )

  return
)