class Html5Video

  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video ["play"], ["pause"], ["ended"], @presentz
    @elementId = @presentz.newElementName()

  handle: (video) -> true

  changeVideo: (videoData, @wouldPlay) ->
    $videoContainer = jQuery(@videoContainer)
    $videoContainer.empty()
    $videoContainer.append("<video id=\"#{@elementId}\" controls preload=\"none\" src=\"#{videoData.url}\" width=\"100%\" height=\"100%\"></video>")

    playerOptions =
      timerRate: 500
      success: (me) =>
        @onPlayerLoaded(me)
        return

    new MediaElementPlayer("##{@elementId}", playerOptions)
    return

  onPlayerLoaded: (@player) ->
    eventHandler = (event) =>
      @video.handleEvent(event.type)
      return
    @player.addEventListener("play", eventHandler, false)
    @player.addEventListener("pause", eventHandler, false)
    @player.addEventListener("ended", eventHandler, false)

    @player.load()
    @play() if @wouldPlay

    return

  currentTime: () ->
    @player.currentTime

  skipTo: (time, wouldPlay = false) ->
    if @player? and @player.currentTime > 0
      @player.setCurrentTime(time)
      @play() if wouldPlay
      true
    false

  play: () ->
    @player.play()

  pause: () ->
    @player.pause()

  isPaused: () ->
    @video.isInPauseState