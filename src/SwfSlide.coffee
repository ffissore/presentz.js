class SwfSlide

  constructor: (@slideContainer) ->
    @sizer = new Sizer(598, 480, @slideContainer)
    @preloadedSlides = []

  handle: (slide) ->
    slide.url.toLowerCase().indexOf(".swf") != -1

  changeSlide: (slide) ->
    if $("##{@slideContainer} object").length == 0
      $("##{@slideContainer}").empty()
      $("##{@slideContainer}").append("<div id='swfslidecontainer'></div>")
      atts = 
        id : "swfslide"
      swfobject.embedSWF(slide.url, "swfslidecontainer", "598", "480", "8", null, null, null, atts)
    else
      swfslide = $("#swfslide")[0]
      swfslide.data = slide.url

    return

  adjustSize: () ->
    newSize = @sizer.optimalSize()
    currentSlide = $("#swfslide")[0]
    if currentSlide and currentSlide.width != newSize.width
      currentSlide.width = newSize.width
      currentSlide.height = newSize.height

  preload: (slides) ->
    $("#swfpreloadslidecontainer").empty()
    index = 0
    for slide in slides when not (slide.url in @preloadedSlides)
      $("##{@slideContainer}").append("<div id='swfpreloadslidecontainer#{index}'></div>")
      atts = 
        id : "swfpreloadslide#{index}"
      caller = this
      swfobject.embedSWF(slide.url, "swfpreloadslidecontainer#{index}", "1", "1", "8", null, null, null, atts, () ->
        caller.preloadedSlides.push slide.url
      )
    return
