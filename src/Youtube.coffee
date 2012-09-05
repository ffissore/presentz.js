class Youtube

  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video [1], [-1, 2], [0], @presentz
    @elementId = @presentz.newElementName()

  changeVideo: (videoData, @wouldPlay) ->
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

  onReady: () =>
    @play() if @wouldPlay

  handleEvent: (event) =>
    @video.handleEvent(event.data)
    return

  handle: (video) ->
    lowerCaseUrl = video.url.toLowerCase()
    lowerCaseUrl.indexOf("//youtu.be/") isnt -1 or lowerCaseUrl.indexOf("//youtube.com/") isnt -1 or lowerCaseUrl.indexOf("//www.youtube.com/") isnt -1

  currentTime: () ->
    return @player.getCurrentTime() if @player.getCurrentTime?
    return 0

  skipTo: (time, wouldPlay = false) ->
    if @player and @player.seekTo
      @player.seekTo(time, true) if wouldPlay or @video.isPaused()
      @play() if wouldPlay
      true
    false

  play: () ->
    @player.playVideo()

  pause: () ->
    @player.pauseVideo()

  isPaused: () ->
    @video.isPaused()

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.Youtube = Youtube
