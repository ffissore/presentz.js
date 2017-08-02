# SpeakerDeck slide plugin handle SpeakerDesk integration
class SpeakerDeck

  # Creates a new instance of a SpeakerDeck slide plugin
  constructor: (@presentz, @slideContainer, @width, @height) ->
    @currentSlide = 0
    @elementId = @presentz.newElementName()
    @speakerdeckOrigin = "*"

  # Called by presentz when looking up a proper slide plugin
  handle: (slide) ->
    return false if !slide.url?
    slide.url.toLowerCase().indexOf("speakerdeck.com") isnt -1

  # Changes slide creating a new iframe (if absent) and establishing "postMessage" driven communication with speakerdeck, calling its API with the new slide index otherwise
  changeSlide: (slide) ->
    if jQuery("#{@slideContainer} iframe.speakerdeck-iframe").length is 0
      $slideContainer = jQuery(@slideContainer)
      $slideContainer.empty()
      slideId = @slideId(slide)

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
      script.src = "//speakerdeck.com/assets/embed.js"
      script.setAttribute("class", "speakerdeck-embed")
      script.setAttribute("data-id", slideId)
      $slideContainer[0].appendChild(script)
      @pingInterval = setInterval(() =>
        $speakerDeckIframe = jQuery("#{@slideContainer} iframe.speakerdeck-iframe")
        if $speakerDeckIframe.length > 0 and $speakerDeckIframe[0].contentWindow
          @speakerdeck = $speakerDeckIframe[0].contentWindow
      , 500)
    else
      if @speakerdeck?
        nextSlide = @slideNumber(slide)
        @speakerdeck.postMessage(JSON.stringify(["goToSlide", nextSlide]), @speakerdeckOrigin)
      else
        console.log "no speakerdeck"
    return

  # Parsers SpeakerDeck url to extract the index of the slide
  slideNumber: (slide) ->
    parseInt(slide.url.substr(slide.url.lastIndexOf("#") + 1))

  # Parsers SpeakerDeck url to extract the ID of the slideshow
  slideId: (slide) ->
    slide.url.substring(slide.url.lastIndexOf("/") + 1, slide.url.lastIndexOf("#"))

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.SpeakerDeck = SpeakerDeck
