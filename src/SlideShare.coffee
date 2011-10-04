class SlideShare

  constructor: (@slideContainer) ->
    @currentSlide = 0
    @sizer = new Sizer(598, 480, @slideContainer)
  
  handle: (slide) ->
    slide.url.toLowerCase().indexOf("http://www.slideshare.net") != -1
    
  changeSlide: (slide) ->
    if $("##{@slideContainer}").children().length == 0
      $("##{@slideContainer}").append("<div id='slidesharecontainer'></div>")
      docId = slide.url.substr(slide.url.lastIndexOf("/") + 1, slide.url.lastIndexOf("#") - 1 - slide.url.lastIndexOf("/"))
      params =
        allowScriptAccess : "always"
      atts = 
        id : "slideshareplayer"
      flashvars = 
        doc: docId
        rel: 0
      
      swfobject.embedSWF("http://static.slidesharecdn.com/swf/ssplayer2.swf", "slidesharecontainer", "598", "480", "8", null, flashvars, params, atts);
      @currentSlide = 0
    else
      player = $("#slideshareplayer")[0]
      nextSlide = slideNumber(slide)
      if player.getCurrentSlide
        currentSlide = player.getCurrentSlide()
        if nextSlide == (currentSlide + 1)
          player.next()
        else
          player.jumpTo(slideNumber(slide))
          @currentSlide = player.getCurrentSlide()
    
    return
    
  slideNumber= (slide) ->
    parseInt(slide.url.substr(slide.url.lastIndexOf("#") + 1))

  adjustSize: () ->
    newSize = @sizer.optimalSize()
    currentSlide = $("#slideshareplayer")[0]
    if currentSlide and currentSlide.width != newSize.width
      currentSlide.width = newSize.width
      currentSlide.height = newSize.height

