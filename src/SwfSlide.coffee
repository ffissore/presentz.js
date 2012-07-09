class SwfSlide

  constructor: (@slideContainer, @width, @height) ->
    @preloadedSlides = []

  handle: (slide) ->
    slide.url.toLowerCase().indexOf(".swf") != -1

  changeSlide: (slide) ->
    if $("#{@slideContainer} object").length == 0
      $(@slideContainer).empty()
      $(@slideContainer).append("<div id=\"swfslidecontainer\"></div>")
      params =
        wmode: "opaque"
      atts =
        id: "swfslide"
      swfobject.embedSWF(slide.url, "swfslidecontainer", @width, @height, "8", null, null, params, atts)
    else
      swfslide = $("#swfslide")[0]
      swfslide.data = slide.url

    return

  preload: (slides) ->
    index = 0
    for slide in slides when !(slide.url in @preloadedSlides)
      $("#swfpreloadslide#{index}").remove()
      $(@slideContainer).append("<div id=\"swfpreloadslidecontainer#{index}\"></div>")
      atts =
        id: "swfpreloadslide#{index}"
        style: "visibility: hidden; position: absolute; margin: 0 0 0 0; top: 0;"
      swfobject.embedSWF slide.url, "swfpreloadslidecontainer#{index}", "1", "1", "8", null, null, null, atts, () =>
        @preloadedSlides.push slide.url
    return
