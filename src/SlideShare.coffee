class SlideShare

  constructor: (@presentz, @slideContainer, @width, @height) ->
    @currentSlide = 0
    @elementId = @presentz.newElementName()
    @swfId = @presentz.newElementName()

  handle: (slide) ->
    #TODO remove subsequent comment to enable slideshare oembed api
    slide.url.toLowerCase().indexOf("slideshare.net") isnt -1 # and !slide.public_url?
    
  slideId: (slide) ->
    slide.url.substr(slide.url.lastIndexOf("/") + 1, slide.url.lastIndexOf("#") - 1 - slide.url.lastIndexOf("/"))

  slideNumber: (slide) ->
    parseInt(slide.url.substr(slide.url.lastIndexOf("#") + 1))

  changeSlide: (slide) ->
    if jQuery("##{@swfId}").length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<div id=\"#{@elementId}\"></div>")
      
      docId = @slideId(slide)
      params =
        allowScriptAccess: "always"
        wmode: "opaque"
      atts =
        id: @swfId
      flashvars =
        doc: docId
        rel: 0

      swfobject.embedSWF("http://static.slidesharecdn.com/swf/ssplayer2.swf", @elementId, @width, @height, "8", null, flashvars, params, atts)
      @currentSlide = 0
    else
      player = jQuery("##{@swfId}")[0]
      nextSlide = @slideNumber(slide)
      if player.getCurrentSlide?
        currentSlide = player.getCurrentSlide()
        if nextSlide is (currentSlide + 1)
          player.next()
        else
          player.jumpTo(@slideNumber(slide))
          @currentSlide = player.getCurrentSlide()

    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.SlideShare = SlideShare
