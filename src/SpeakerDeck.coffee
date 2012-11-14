class SpeakerDeck

  constructor: (@presentz, @slideContainer, @width, @height) ->
    @currentSlide = 0
    @elementId = @presentz.newElementName()

  handle: (slide) ->
    slide.url.toLowerCase().indexOf("speakerdeck.com") isnt -1

  changeSlide: (slide) ->
    if jQuery("#{@slideContainer} iframe.speakerdeck-iframe").length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      slideId = slide.url.substring(slide.url.lastIndexOf("/") + 1, slide.url.lastIndexOf("#"))

      receiveMessage = (event) =>
        return if event.origin.indexOf("speakerdeck.com") is -1
        @speakerdeckOrigin = event.origin
        @speakerdeck = event.source
        data = JSON.parse(event.data)
        @currentSlide = data[1].number if data[0] is "change"

      window.addEventListener "message", receiveMessage, false

      script = document.createElement("script")
      script.type = "text/javascript"
      script.async = true
      script.src = "http://speakerdeck.com/assets/embed.js"
      script.setAttribute("class", "speakerdeck-embed")
      script.setAttribute("data-id", slideId)
      $slideContainer[0].appendChild(script)
    else
      if @speakerdeck?
        nextSlide = @slideNumber(slide)
        @speakerdeck.postMessage JSON.stringify(["goToSlide", nextSlide]), @speakerdeckOrigin
    return

  slideNumber: (slide) ->
    parseInt(slide.url.substr(slide.url.lastIndexOf("#") + 1))

  slideId: (slide) ->
    slide.url.substr(slide.url.lastIndexOf("/") + 1, slide.url.lastIndexOf("#") - 1 - slide.url.lastIndexOf("/"))
