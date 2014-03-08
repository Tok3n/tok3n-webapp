# Webfonts
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

# Ladda
Ladda.bind '#tok3nLogin', {timeout: 5000}

Ladda.bind '#tok3nVerify', {timeout: 5000}

document.getElementById("tok3nOtpInput").oninput = ->
  @value = @value.slice(0, 6)  if @value.length > 6
  return

document.getElementById("tok3nSmsInput").oninput = ->
  @value = @value.slice(0, 6)  if @value.length > 6
  return


# Google Analytics
root = exports ? this
root._gaq = [['_setAccount', 'UA-39917560-2'], ['_trackPageview']]

insertGAScript = ->
  ga = document.createElement 'script'
  ga.type = 'text/javascript'
  ga.async = true
 
  proto = document.location.protocol
  proto = if (proto is 'https:') then 'https://ssl' else 'http://www'
  ga.src = "#{proto}.google-analytics.com/ga.js"
  
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore ga, s

insertGAScript()