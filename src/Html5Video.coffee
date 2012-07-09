class Html5Video

  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video "play", "pause", "ended", @presentz
    @elementId = @presentz.newElementName()

  changeVideo: (videoData, @wouldPlay) ->
    $(@videoContainer).empty()
    videoHtml = "<video id=\"#{@elementId}\" controls preload=\"none\" src=\"#{videoData.url}\" width=\"#{@width}\" height=\"#{@height}\"></video>"
    $(@videoContainer).append(videoHtml)

    playerOptions =
      enableAutosize: false
      timerRate: 500
      success: (me) =>
        @onPlayerLoaded me
        return

    new MediaElementPlayer("##{@elementId}", playerOptions)
    return

  onPlayerLoaded: (@player) ->
    eventHandler= (event) =>
      @video.handleEvent event.type
      return
    player.addEventListener("play", eventHandler, false)
    player.addEventListener("pause", eventHandler, false)
    player.addEventListener("ended", eventHandler, false)

    @player.load()

    if @wouldPlay
      if !@presentz.intervalSet
        @presentz.startTimeChecker()
      @player.play()

  currentTime: () ->
    return @player.currentTime

  skipTo: (time) ->
    if @player and @player.currentTime
      @player.setCurrentTime(time)
      return true
    return false