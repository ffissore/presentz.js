class YoutubeIFrame

  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video 1, 2, 0, @presentz
    @elementId = @presentz.newElementName()

  changeVideo: (videoData, @wouldPlay) ->
    if $(@videoContainer).children().length is 0
      $(@videoContainer).append("<div id=\"#{@elementId}\"></div>")

      @player = new YT.Player @elementId,
        height: @height
        width: @width
        videoId: videoId(videoData)
        playerVars:
          rel: 0
          wmode: "opaque"
        events:
          onReady: @onReady
          onStateChange: @handleEvent
    else
      @player.cueVideoById(videoId(videoData))
    return

  videoId= (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  onReady: () =>
    if !@presentz.intervalSet
      @presentz.startTimeChecker()
    if @wouldPlay
      @player.playVideo()

  handleEvent: (event) =>
    @video.handleEvent(event.data)
    return

  handle: (presentation) ->
    presentation.chapters[0].video.url.toLowerCase().indexOf("http://youtu.be") != -1

  currentTime: () ->
    return @player.getCurrentTime() if @player.getCurrentTime?
    return 0

  skipTo: (time, wouldPlay = false) ->
    if time > 0 and @player and @player.seekTo
      @player.seekTo(time, true)
      @player.playVideo() if wouldPlay
      true
    false

  play: () ->
    @player.playVideo()

  pause: () ->
    @player.pauseVideo()

  isPaused: () ->
    @video.isPaused()