class ImgSlide

  constructor: (@presentz, @slideContainer) ->
    @preloadedSlides = []

  handle: (slide) -> true

  changeSlide: (slide) ->
    if jQuery("#{@slideContainer} img").length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<img src=\"#{slide.url}\"/>")
    else
      jQuery("#{@slideContainer} img").attr "src", slide.url
    return

  preload: (slide) ->
    return if (slide.url in @preloadedSlides)
    image = new Image()
    image.src = slide.url
    return