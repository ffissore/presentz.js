class RvlIO

  constructor: (@presentz, @slideContainer) ->
    @preloadedSlides = []

  handle: (slide) ->
    slide.url.toLowerCase().indexOf("rvl.io") isnt -1

  changeSlide: (slide) ->
    if jQuery("#{@slideContainer} iframe.revealjs").length is 0
      jQuery(@slideContainer).empty()
      jQuery(@slideContainer).append("<iframe frameborder=\"0\" class=\"revealjs\" src=\"#{slide.url}\"></iframe>")
    else
      jQuery("#{@slideContainer} iframe.revealjs").attr "src", slide.url
    return
