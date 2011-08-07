params = window.location.search.substring(1).split("&")
importExternalJS param for param in params when param.indexOf("p=") == 0 && param.length > 2

importExternalJS = (param) ->
  scriptUrl = param.substr(2)

  script = document.createElement('script')
  script.type = 'text/javascript'
  script.src = scriptUrl

  scripts = $("script")
  $(scripts[scripts.length - 1]).append(script);