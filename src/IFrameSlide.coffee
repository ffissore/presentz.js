class IFrameSlide

  constructor: (@presentz, @slideContainer) ->
    @iframeSelector = "#{@slideContainer} iframe.iframe-slide-container"

  handle: (slide) ->
    return slide.url?

  changeSlide: (slide) ->
    $iframe = jQuery(@iframeSelector)
    if $iframe.length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<iframe frameborder=\"0\" class=\"iframe-slide-container\" src=\"#{slide.url}\"></iframe>")
    else
      $iframe.attr("src", slide.url)
    return
