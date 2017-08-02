# SlideShare slide plugin handles SlideShare integration
# DEPRECATED: SlideShare dropped the Player API. Use SlideShareOEmbed
class SlideShare

  # Creates a new instance of a SlideShare slide plugin
  constructor: (@presentz, @slideContainer, @width, @height) ->
    @currentSlide = 0
    @elementId = @presentz.newElementName()
    @swfId = @presentz.newElementName()

  # Called by presentz when looking up a proper slide plugin
  handle: (slide) ->
    return false if !slide.url?
    #{TODO remove subsequent comment to enable slideshare oembed api}
    slide.url.toLowerCase().indexOf("slideshare.net") isnt -1 # and !slide.public_url?

  # Parsers SlideShare url to extract the ID of the slideshow
  slideId: (slide) ->
    slide.url.substr(slide.url.lastIndexOf("/") + 1, slide.url.lastIndexOf("#") - 1 - slide.url.lastIndexOf("/"))

  # Parsers SlideShare url to extract the index of the slide
  slideNumber: (slide) ->
    parseInt(slide.url.substr(slide.url.lastIndexOf("#") + 1))

  # Changes slide, embedding a SlideShare flash player if none was present, setting a new slide index otherwise
  changeSlide: (slide) ->
    $swf = jQuery("##{@swfId}")
    if $swf.length is 0
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
      player = $swf[0]
      nextSlide = @slideNumber(slide)
      if player.getCurrentSlide?
        currentSlide = player.getCurrentSlide()
        # Trying to call "next" slide on SlideShare player as this makes the big fat right arrow disappear
        if nextSlide is (currentSlide + 1)
          player.next()
        else
          player.jumpTo(@slideNumber(slide))
          @currentSlide = player.getCurrentSlide()

    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.SlideShare = SlideShare
