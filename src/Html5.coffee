class Html5Video

  constructor: (@presentz) ->
    @video = new Video "play", "pause", "ended", @presentz

  changeVideo: (videoData, play) ->
    if $("#videoContainer").children().length == 0
      videoHtml = "<video controls preload='none' src='#{ videoData.url }' width='100%'></video>"
      $("#videoContainer").append(videoHtml)

      caller = this
      eventHandler = `function(event) {
        caller.video.handleEvent(event.type);
      }`
      @player = $("#videoContainer > video")[0]
      @player.onplay = eventHandler
      @player.onpause = eventHandler
      @player.onended = eventHandler
    else
      @player.setAttribute("src", videoData.url)

    @player.load()

    if play
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
        
      @player.play()

    return

  currentTime: () ->
    return presentz.videoPlugin.player.currentTime