WebFontConfig = google:
  families: [
    "Arvo:400italic:latin"
  ]
(->
  wf = document.createElement("script")
  wf.src = ((if "https:" is document.location.protocol then "https" else "http")) + "://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js"
  wf.type = "text/javascript"
  wf.async = "true"
  s = document.getElementsByTagName("script")[0]
  s.parentNode.insertBefore wf, s
  return
)()

Ladda.bind '.tok3n-submit button#tok3nLogin', {timeout: 5000}

Ladda.bind '.tok3n-submit button#tok3nOtpButton', {timeout: 5000}

document.getElementById("tok3nOtpInput").oninput = ->
  @value = @value.slice(0, 6)  if @value.length > 6
  return