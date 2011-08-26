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

    @player = new MediaElementPlayer("#html5player", playerOptions)

    @player.load()

    if @wouldPlay
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
        
      @player.play()

    return
    
  onPlayerLoaded: (player) ->
    caller = this
    eventHandler = (event) ->
      caller.adjustVideoSize()
      caller.video.handleEvent event.type
      return
    player.addEventListener('play', eventHandler, false);
    player.addEventListener('pause', eventHandler, false);
    player.addEventListener('ended', eventHandler, false);
    if  @wouldPlay
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
      @player.play()

  adjustVideoSize: () ->
    if presentz.videoPlugin.player.height < $("#html5player").height()
      newHeight = $("#html5player").height()
      $("#videoContainer").height(newHeight)
      $(".mejs-container").height(newHeight)
      presentz.videoPlugin.player.height = newHeight

  currentTime: () ->
    presentz.videoPlugin.adjustVideoSize()
    return presentz.videoPlugin.player.getCurrentTime()