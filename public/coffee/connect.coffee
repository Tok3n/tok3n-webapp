Ladda.bind '.tok3n-submit button#tok3nLogin', {timeout: 5000}

Ladda.bind '.tok3n-submit button#tok3nOtpButton', {timeout: 5000}

document.getElementById("tok3nOtpInput").oninput = ->
  @value = @value.slice(0, 6)  if @value.length > 6
  return