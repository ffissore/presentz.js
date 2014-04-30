

# Sambatech video plugin handles Sambatech integration
class SambatechPlugin

  IFRAME_API = "http://player.sambatech.com.br/v2current/samba.player.api.js/media/js/api/samba.player.api.parent.js"
  constructor: (@presentz, @videoContainer, @width, @height) ->

  # Creates a new instance of the Sambatech video plugin
    @video = new Video ["play"], ["pause"], ["end"], @presentz
    @elementId = @presentz.newElementName()
    @videoData = null
    @time = 0
  # Ensure the Sambatech IFrame API is loaded
  ensureSambatechIframeAPILoaded: (callback) ->
#    <script ="player" name="samba-player-api" type="text/javascript" src=""></script>
    if jQuery("script[src=\"#{IFRAME_API}\"]").length is 0
      script = document.createElement("script")
      script.type = "text/javascript"
      script.setAttribute("samba-player-api", "player")
      script.setAttribute("name", "samba-player-api")
      script.onload = callback
      script.src = IFRAME_API
      $scripts = jQuery("script")
      if $scripts.length is 0
        jQuery(@videoContainer)[0].appendChild(script)
      else
        firstScriptTag = $scripts[0]
        firstScriptTag.parentNode.insertBefore(script, firstScriptTag)
    else
      callback()
    return

  changeVideo: (videoData, @wouldPlay) ->
    @videoData = videoData

    @ensureSambatechIframeAPILoaded () =>

      root.videoSamba = @video
      root.wouldPlaySamba = @wouldPlay
      @player = new SambaPlayer("player_video", #player é o ID do elemento html que ele vai inserir o iframe
        height: @height
        width: @width
        ph: @playerKey(videoData) #Player Hash do projeto
        m: @videoId(videoData) #MidiaID


        events: #Funcoes que escutam os eventos do player
          onLoad: "onLoadSamba",
          onStart: "onStartSamba",
          onPause: "onPauseSamba",
          onFinish: "onFinishedSamba",
          onResume: "onStartSamba"
      )

      return

  # Parsers Sambatech url to extract the ID of the video
  videoId: (videoData) ->
    lowercaseUrl = videoData.url.toLowerCase()
    id = videoData.url
    if lowercaseUrl.indexOf("http://player.sambatech.com.br/current/samba-player.js") isnt -1
      id = id.substr(id.indexOf("m=") + 2)
      id = id.substr(0, id.indexOf("&")) if id.indexOf("&") isnt -1
    id

  # Parsers Sambatech url to extract the ID of the video
  playerKey: (videoData) ->
    lowercaseUrl = videoData.url.toLowerCase()
    id = videoData.url
    if lowercaseUrl.indexOf("http://player.sambatech.com.br/current/samba-player.js") isnt -1
      id = id.substr(id.indexOf("ph=") + 3)
      id = id.substr(0, id.indexOf("&")) if id.indexOf("&") isnt -1
    id


  # Called by the Sambatech player when the video state changes
  handleEvent: (event) =>
    @video.handleEvent(event.data)
    return
  # Called by presentz when looking up a proper video plugin
  handle: (video) ->
    lowerCaseUrl = video.url.toLowerCase()
    lowerCaseUrl.indexOf("http://player.sambatech.com.br/current/samba-player.js") isnt -1

  # Gets the current time of the played video
  currentTime: () ->
    return 0

  # Skips the video to the given time
  skipTo: (time, wouldPlay = false) ->
    if @player?.seek?
      @player.seek(time) if wouldPlay or @isPaused()
      @player.play() if wouldPlay
      true
    false

  # Pauses the video
  pause: () ->
    @player.pause()

  # Returns the pause state of the video
  isPaused: () ->
    @video.isInPauseState

  onStartSamba: () ->
    videoSamba.handleEvent("play");

  onPauseSamba: () ->
    videoSamba.handleEvent("pause");

  onFinishedSamba: () ->
    videoSamba.handleEvent("end");

  onLoadSamba: () ->
    if wouldPlaySamba
      videoSamba.play();

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.SambatechPlugin = SambatechPlugin
root.onStartSamba = SambatechPlugin.prototype.onStartSamba
root.onPauseSamba = SambatechPlugin.prototype.onPauseSamba
root.onFinishedSamba = SambatechPlugin.prototype.onFinishedSamba
root.onLoadSamba = SambatechPlugin.prototype.onLoadSamba
root.videoSamba = null;
root.wouldPlaySamba = null;
