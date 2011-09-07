class Html5Video

  constructor: (@presentz) ->
    @video = new Video "play", "pause", "ended", @presentz

  changeVideo: (videoData, @wouldPlay) ->
    $("#videoContainer").empty()
    availableWidth = $("#videoContainer").width()
    videoHtml = "<video id='html5player' controls preload='none' src='#{ videoData.url }' width='#{availableWidth}'></video>"
    $("#videoContainer").append(videoHtml)
    
    caller = this
    playerOptions =
      enableAutosize: false
      timerRate: 500
      success: (me) ->
        caller.onPlayerLoaded me
        return

    new MediaElementPlayer("#html5player", playerOptions)
    return
    
  onPlayerLoaded: (@player) ->
    caller = this
    eventHandler = (event) ->
      caller.video.handleEvent event.type
      return
    player.addEventListener("play", eventHandler, false);
    player.addEventListener("pause", eventHandler, false);
    player.addEventListener("ended", eventHandler, false);
    
    @player.load()

    if @wouldPlay
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
      @player.play()

  adjustSize: () ->
    if @player.height != $("#html5player").height()
      newHeight = $("#html5player").height()
      $("#videoContainer").height(newHeight)
      $(".mejs-container").height(newHeight)
      @player.height = newHeight
    return

  currentTime: () ->
    return @player.currentTime

  skipTo: (time) ->
    if @player and @player.currentTime
      @player.setCurrentTime(time)
      return true
    return false