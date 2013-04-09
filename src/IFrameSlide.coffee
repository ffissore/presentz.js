# IFrameSlide slide plugin handles whatever slide can't be embedded as an image or a flash thing. A website for example
class IFrameSlide

  # Creates a new instance of the IFrameSlide slide plugin
  constructor: (@presentz, @slideContainer) ->
    @iframeSelector = "#{@slideContainer} iframe.iframe-slide-container"

  # Called by presentz when looking up a proper slide plugin
  handle: (slide) ->
    return slide.url?

  # Changes slide, creating an iframe with the given url, changing its src attribute otherwise
  changeSlide: (slide) ->
    $iframe = jQuery(@iframeSelector)
    if $iframe.length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<iframe frameborder=\"0\" class=\"iframe-slide-container\" src=\"#{slide.url}\"></iframe>")
    else
      $iframe.attr("src", slide.url)
    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.IFrameSlide = IFrameSlide
