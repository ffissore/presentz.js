importExternalJS = (param) ->
  scriptUrl = param.substr(2)

  ajaxCall =
    url: scriptUrl
    dataType: "jsonp"
    jsonpCallback: "initPresentz"

  $.ajax ajaxCall
  return
    
params = window.location.search.substring(1).split("&")
importExternalJS param for param in params when param.indexOf("p=") == 0 && param.length > 2