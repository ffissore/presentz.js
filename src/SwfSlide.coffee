class SwfSlide
  
  handle: (slide) ->
    slide.url.toLowerCase().indexOf(".swf") != -1
    
  changeSlide: (slide) ->
    if $("#slideContainer object").length == 0
      $("#slideContainer").empty()
      $("#slideContainer").append("<div id='swfslidecontainer'></div>")
      atts = 
        id : "swfslide"
      swfobject.embedSWF(slide.url, "swfslidecontainer", "598", "480", "8", null, null, null, atts);
    else
      swfslide = $("#swfslide")[0]
      swfslide.data = slide.url
    
    adjustSlideSize()
    return

  adjustSlideSize= () ->
    newWidth = $("#slideContainer").width()
    currentSlide = $("#swfslide")[0]
    if currentSlide.width != newWidth
      newHeight = newWidth * (currentSlide.height / currentSlide.width)
      $("#swfslide")[0].width = newWidth;
      $("#swfslide")[0].height = newHeight

