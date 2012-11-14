class SwfSlide

  constructor: (@presentz, @slideContainer, @width, @height) ->
    @preloadedSlides = []
    @elementId = @presentz.newElementName()
    @swfId = @presentz.newElementName()
    @preloadSlideContainerId = @presentz.newElementName()
    @preloadSlideId = @presentz.newElementName()

  handle: (slide) ->
    slide.url.toLowerCase().indexOf(".swf") isnt -1

  changeSlide: (slide) ->
    if jQuery("##{@swfId}").length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<div id=\"#{@elementId}\"></div>")
      params =
        wmode: "opaque"
      atts =
        id: @swfId
      swfobject.embedSWF(slide.url, @elementId, @width, @height, "8", null, null, params, atts)
    else
      swfslide = jQuery("##{@swfId}")[0]
      swfslide.data = slide.url

    return

  preload: (slide) ->
    return if (slide.url in @preloadedSlides)

    jQuery("##{@preloadSlideId}").remove()
    jQuery(@slideContainer).append("<div id=\"#{@preloadSlideContainerId}\"></div>")
    atts =
      id: "#{@preloadSlideId}"
      style: "visibility: hidden; position: absolute; margin: 0 0 0 0; top: 0;"
    swfobject.embedSWF slide.url, "#{@preloadSlideContainerId}", "1", "1", "8", null, null, null, atts, () =>
      @preloadedSlides.push(slide.url)
    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.SwfSlide = SwfSlide