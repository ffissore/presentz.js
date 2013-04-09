# Youtube video plugin handles Youtube integration
class Youtube

  IFRAME_API = "//www.youtube.com/iframe_api"
  
  # Creates a new instance of the Youtube video plugin
  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video [1], [-1, 2], [0], @presentz
    @elementId = @presentz.newElementName()

  # Ensure the Youtube IFrame API is loaded: if not, it will add a &lt;script&gt; tag to the DOM and wait for the API to call onYouTubeIframeAPIReady function
  ensureYoutubeIframeAPILoaded: (callback) ->
    if jQuery("script[src=\"#{IFRAME_API}\"]").length is 0
      script = document.createElement("script")
      script.type = "text/javascript"
      script.async = true
      script.src = IFRAME_API
      $scripts = jQuery("script")
      if $scripts.length is 0
        #{old behaviour}
        jQuery(@videoContainer)[0].appendChild(script)
      else
        #{code suggested by https://developers.google.com/youtube/iframe_api_reference}
        firstScriptTag = $scripts[0]
        firstScriptTag.parentNode.insertBefore(script, firstScriptTag)
      window.onYouTubeIframeAPIReady = () ->
        callback()
    else
      callback()
    return

  # Changes video, creating a new Youtube player (if none was present) with the given video, queueing it otherwise
  changeVideo: (videoData, @wouldPlay) ->
    @ensureYoutubeIframeAPILoaded () =>
      if jQuery("##{@elementId}").length is 0
        jQuery(@videoContainer).append("<div id=\"#{@elementId}\"></div>")
  
        @player = new YT.Player @elementId,
          height: @height
          width: @width
          videoId: @videoId(videoData)
          playerVars:
            rel: 0
            wmode: "opaque"
          events:
            onReady: @onReady
            onStateChange: @handleEvent
      else
        @player.cueVideoById(@videoId(videoData))
        
      return
      
    return

  # Parsers Youtube url to extract the ID of the video
  videoId: (videoData) ->
    lowercaseUrl = videoData.url.toLowerCase()
    id = videoData.url
    if lowercaseUrl.indexOf("//youtu.be/") isnt -1
      id = id.substr(id.lastIndexOf("/") + 1)
      id = id.substr(0, id.indexOf("?")) if id.indexOf("?") isnt -1
    else if lowercaseUrl.indexOf("//youtube.com/") isnt -1 or lowercaseUrl.indexOf("//www.youtube.com/") isnt -1
      id = id.substr(id.indexOf("v=") + 2)
      id = id.substr(0, id.indexOf("&")) if id.indexOf("&") isnt -1
    id

  # Called by the Youtube player when the video is ready to play
  onReady: () =>
    @play() if @wouldPlay

  # Called by the Youtube player when the video state changes
  handleEvent: (event) =>
    @video.handleEvent(event.data)
    return

  # Called by presentz when looking up a proper video plugin
  handle: (video) ->
    lowerCaseUrl = video.url.toLowerCase()
    lowerCaseUrl.indexOf("//youtu.be/") isnt -1 or lowerCaseUrl.indexOf("//youtube.com/") isnt -1 or lowerCaseUrl.indexOf("//www.youtube.com/") isnt -1

  # Gets the current time of the played video
  currentTime: () ->
    return @player.getCurrentTime() if @player?.getCurrentTime?
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
root.presentz.Youtube = Youtube
