# SlideShareOEmbed is an experimental alternative to the SlideShare plugin. It doesn't use flash. Experimentation proved that SlideShare images naming is still not stable (or the documentation is incomplete): correct urls bring to 404 responses. Too bad.
class SlideShareOEmbed

  # Creates a new instance of the SlideShareOEmbed slide plugin
  constructor: (@presentz, @slideContainer) ->
    @elementId = @presentz.newElementName()
    @preloadedSlides = []
    @slideInfo = {}

  # Called by presentz when looking up a proper slide plugin
  handle: (slide) ->
    return false if !slide.url?
    slide.url.toLowerCase().indexOf("slideshare.net") isnt -1 and slide.public_url?

  # Parsers SlideShare url to extract the index of the slide
  slideNumber: (slide) ->
    parseInt(slide.url.substr(slide.url.lastIndexOf("#") + 1))

  # Ensures slideshow info is already available
  ensureSlideInfoFetched: (slidePublicUrl, callback) ->
    return callback() if @slideInfo[slidePublicUrl]?
    
    jQuery.ajax
      url: "//www.slideshare.net/api/oembed/2"
      data:
        url: slidePublicUrl
        format: "json"
      dataType: "jsonp"
      success: (slideinfo) =>
        @slideInfo[slidePublicUrl] = slideinfo
        callback()
    
    return

  # Builds the URL of the image from the given slide
  urlOfSlide: (slide) ->
    slideInfo = @slideInfo[slide.public_url]
    if slideInfo.conversion_version is 2
      "#{slideInfo.slide_image_baseurl}#{@slideNumber(slide)}#{slideInfo.slide_image_baseurl_suffix}"
    else
      "#{slideInfo.slide_image_baseurl}-slide-#{@slideNumber(slide)}#{slideInfo.slide_image_baseurl_suffix}"

  # Changes slide, creating a &lt;img&gt; tag or changing its src attribute
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

  # Preloads the given slide
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
