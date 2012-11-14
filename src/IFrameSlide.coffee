class IFrameSlide

  constructor: (@presentz, @slideContainer) ->
    @selector = "#{@slideContainer} iframe.iframe-slide-container"

  handle: () -> true

  changeSlide: (slide) ->
    if jQuery(@selector).length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<iframe frameborder=\"0\" class=\"iframe-slide-container\" src=\"#{slide.url}\"></iframe>")
    else
      jQuery(@selector).attr("src", slide.url)
    return
