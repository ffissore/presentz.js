# ImgSlide slide plugin handles plain images
class ImgSlide

  # Creates a new instance of the ImgSlide slide plugin
  constructor: (@presentz, @slideContainer) ->
    @preloadedSlides = []

  # Called by presentz when looking up a proper slide plugin
  handle: (slide) -> 
    return slide.url?

  # Changes slide, creating an image with the given url, changing its src attribute otherwise
  changeSlide: (slide) ->
    $img = jQuery("#{@slideContainer} img")
    if $img.length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<img src=\"#{slide.url}\"/>")
    else
      $img.attr("src", slide.url)
    return

  # Preloads the given slide
  preload: (slide) ->
    return if (slide.url in @preloadedSlides)
    image = new Image()
    image.src = slide.url
    @preloadedSlides.push(slide.url)
    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.ImgSlide = ImgSlide
