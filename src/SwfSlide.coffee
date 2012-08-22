class SwfSlide

  constructor: (@presentz, @slideContainer, @width, @height) ->
    @preloadedSlides = []
    @elementId = @presentz.newElementName()
    @swfId = @presentz.newElementName()
    @preloadSlideContainerId = @presentz.newElementName()
    @preloadSlideId = @presentz.newElementName()

  handle: (slide) ->
    slide.url.toLowerCase().indexOf(".swf") != -1

  changeSlide: (slide) ->
    if jQuery("#{@slideContainer} object").length is 0
      jQuery(@slideContainer).empty()
      jQuery(@slideContainer).append("<div id=\"#{@elementId}\"></div>")
      params =
        wmode: "opaque"
      atts =
        id: @swfId
      swfobject.embedSWF(slide.url, @elementId, @width, @height, "8", null, null, params, atts)
    else
      swfslide = jQuery("##{@swfId}")[0]
      swfslide.data = slide.url

    return

  preload: (slides) ->
    index = 0
    for slide in slides when !(slide.url in @preloadedSlides)
      jQuery("##{@preloadSlideId}#{index}").remove()
      jQuery(@slideContainer).append("<div id=\"#{@preloadSlideContainerId}#{index}\"></div>")
      atts =
        id: "#{@preloadSlideId}#{index}"
        style: "visibility: hidden; position: absolute; margin: 0 0 0 0; top: 0;"
      swfobject.embedSWF slide.url, "#{@preloadSlideContainerId}#{index}", "1", "1", "8", null, null, null, atts, () =>
        @preloadedSlides.push slide.url
    return
