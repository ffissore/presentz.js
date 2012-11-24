class ImgSlide

  constructor: (@presentz, @slideContainer) ->
    @preloadedSlides = []

  handle: (slide) -> true

  changeSlide: (slide) ->
    $img = jQuery("#{@slideContainer} img")
    if $img.length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<img src=\"#{slide.url}\"/>")
    else
      $img.attr("src", slide.url)
    return

  preload: (slide) ->
    return if (slide.url in @preloadedSlides)
    image = new Image()
    image.src = slide.url
    @preloadedSlides.push(slide.url)
    return