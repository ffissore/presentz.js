# Wistia video plugin handles Wistia integration
class WistiaPlugin

  IFRAME_API = "//fast.wistia.com/assets/external/E-v1.js"
  
  # Creates a new instance of the Wistia video plugin
  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video ["play"], ["pause"], ["end"], @presentz
    @elementId = @presentz.newElementName()

  # Ensure the Wistia IFrame API is loaded
  ensureWistiaIframeAPILoaded: (callback) ->
    if jQuery("script[src=\"#{IFRAME_API}\"]").length is 0
      script = document.createElement("script")
      script.type = "text/javascript"
      script.src = IFRAME_API
      script.onload = callback
      $scripts = jQuery("script")
      if $scripts.length is 0
        jQuery(@videoContainer)[0].appendChild(script)
      else
        firstScriptTag = $scripts[0]
        firstScriptTag.parentNode.insertBefore(script, firstScriptTag)
    else
      callback()
    return

  # Changes video, creating a new Wistia player (if none was present) with the given video, queueing it otherwise
  changeVideo: (videoData, @wouldPlay) ->
    jQuery(@videoContainer).append "<div id='wistia_#{@videoId(videoData)}' class='wistia_embed' style='width:#{@width}px;height:#{@height}px;'>&nbsp;</div>"
    @ensureWistiaIframeAPILoaded () =>
      jQuery(@videoContainer).append("<div id=\"#{@elementId}\"></div>")

      @player = Wistia.embed @videoId(videoData),
        version: "v1",
        videoWidth: @width,
        videoHeight: @height,
        playerColor: "688AAD"

      @player.bind "ready", ->
        @onReady
      video = @video
      @player.bind "play", ->
        video.handleEvent("play")
      @player.bind "pause", ->
        video.handleEvent("pause")
      @player.bind "end", ->
        video.handleEvent("end")

      return

  # Parsers Wistia url to extract the ID of the video
  videoId: (videoData) ->
    lowercaseUrl = videoData.url.toLowerCase()
    id = videoData.url
    if lowercaseUrl.indexOf("//www.wistia.com/") isnt -1
      id = id.substr(id.lastIndexOf("/") + 1)

      id = id.substr(0, id.indexOf("?")) if id.indexOf("?") isnt -1
    id
  # Called by the Wistia player when the video is ready to play
  onReady: () =>
    @play() if @wouldPlay

  # Called by the Wistia player when the video state changes
  handleEvent: (event) =>
    @video.handleEvent(event.data)
    return
  # Called by presentz when looking up a proper video plugin
  handle: (video) ->
    lowerCaseUrl = video.url.toLowerCase()
    lowerCaseUrl.indexOf("//www.wistia.com/") isnt -1

  # Gets the current time of the played video
  currentTime: () ->
    return @player.time() if @player?.time?
    return 0

  # Skips the video to the given time
  skipTo: (time, wouldPlay = false) ->
    if @player?.seekTo?
      @player.seekTo(time, true) if wouldPlay or @isPaused()
      @play() if wouldPlay
      true
    false

  # Starts playing the video
  play: () ->

    @player.playVideo()

  # Pauses the video
  pause: () ->
    @player.pauseVideo()

  # Returns the pause state of the video
  isPaused: () ->
    @video.isInPauseState

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.WistiaPlugin = WistiaPlugin
