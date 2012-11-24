class SlideShareOEmbed

  constructor: (@presentz, @slideContainer) ->
    @elementId = @presentz.newElementName()
    @preloadedSlides = []
    @slideInfo = {}

  handle: (slide) ->
    slide.url.toLowerCase().indexOf("slideshare.net") isnt -1 and slide.public_url?

  slideNumber: (slide) ->
    parseInt(slide.url.substr(slide.url.lastIndexOf("#") + 1))
    
  ensureSlideInfoFetched: (slidePublicUrl, callback) ->
    return callback() if @slideInfo[slidePublicUrl]?
    
    jQuery.ajax
      url: "http://www.slideshare.net/api/oembed/2"
      data:
        url: slidePublicUrl
        format: "json"
      dataType: "jsonp"
      success: (slideinfo) =>
        @slideInfo[slidePublicUrl] = slideinfo
        callback()
    
    return

  urlOfSlide: (slide) ->
    slideInfo = @slideInfo[slide.public_url]
    if slideInfo.conversion_version is 2
      "#{slideInfo.slide_image_baseurl}#{@slideNumber(slide)}#{slideInfo.slide_image_baseurl_suffix}"
    else
      "#{slideInfo.slide_image_baseurl}-slide-#{@slideNumber(slide)}#{slideInfo.slide_image_baseurl_suffix}"

  changeSlide: (slide) ->
    if jQuery("##{@elementId}").length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      $slideContainer.append("<div id=\"#{@elementId}\"></div>")

    @ensureSlideInfoFetched slide.public_url, () =>
      $img = jQuery("##{@elementId} img")
      if $img.length is 0
        jQuery("##{@elementId}").append("<img src=\"#{@urlOfSlide(slide)}\"/>")
      else
        $img.attr("src", @urlOfSlide(slide))

    return


  preload: (slide) ->
    return unless slide.public_url?
    @ensureSlideInfoFetched slide.public_url, () =>
      url = @urlOfSlide(slide)
      return if (url in @preloadedSlides)
      image = new Image()
      image.src = url
      @preloadedSlides.push(url)
    return
    
root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.SlideShareOEmbed = SlideShareOEmbed
