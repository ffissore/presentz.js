class Html5Video

  constructor: (@presentz) ->
    @video = new Video "play", "pause", "ended", @presentz

  changeVideo: (videoData, play) ->
    if $("#videoContainer").children().length == 0
      availableWidth = $("#videoContainer").width()
      videoHtml = "<video id='html5player' controls preload='none' src='#{ videoData.url }' width='#{availableWidth}'></video>"
      $("#videoContainer").append(videoHtml)
      
      caller = this
      successHandler = `function(me, a, b, c) {
        caller.onPlayerLoaded(me);
      }`

      playerOptions =
        enableAutosize: false
        timerRate: 500
        success: successHandler

      @player = new MediaElementPlayer("#html5player", playerOptions)
    else
      $("#html5player")[0].src = videoData.url

    @player.load()

    if play
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
        
      @player.play()

    return
    
  onPlayerLoaded: (player) ->
    caller = this
    eventHandler = `function(event) {
      caller.adjustVideoSize()
      caller.video.handleEvent(event.type);
    }`
    player.addEventListener('play', eventHandler, false);
    player.addEventListener('pause', eventHandler, false);
    player.addEventListener('ended', eventHandler, false);

  adjustVideoSize: () ->
    if presentz.videoPlugin.player.height < $("#html5player").height()
      console.log $("#html5player").height()
      console.log $("#html5player").width()
      console.log $(".mejs-container").height()
      newHeight = $("#html5player").height()
      $("#videoContainer").height(newHeight)
      $(".mejs-container").height(newHeight)
      presentz.videoPlugin.player.height = newHeight

  currentTime: () ->
    presentz.videoPlugin.adjustVideoSize()
    return presentz.videoPlugin.player.getCurrentTime()