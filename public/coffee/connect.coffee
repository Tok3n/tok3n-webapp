Ladda.bind 'button#tok3n_otp', {timeout: 5000}

document.getElementById("tok3n_otp").oninput = ->
  @value = @value.slice(0, 6)  if @value.length > 6
  return