class Youtube

  constructor: (@presentz) ->
    @video = new Video 1, 2, 0, @presentz
    @sizer = new Sizer(425, 356, "videoContainer")
    window.onYouTubePlayerReady = @onYouTubePlayerReady

  changeVideo: (videoData, @wouldPlay) ->
    movieUrl = "http://www.youtube.com/e/#{ videoId(videoData) }?enablejsapi=1&playerapiid=ytplayer"

    if $("#videoContainer").children().length == 0
      $("#videoContainer").append("<div id='youtubecontainer'></div>")
      params =
        allowScriptAccess : "always"
      atts = 
        id : "ytplayer"
      
      swfobject.embedSWF(movieUrl, "youtubecontainer", "#{ @sizer.startingWidth }", "#{ @sizer.startingHeight }", "8", null, null, params, atts);
    else
      @player.cueVideoByUrl(movieUrl)

    if @wouldPlay and @player != undefined
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
      @player.playVideo()

    return

  videoId = (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://youtu.be") != -1

  onYouTubePlayerReady: (id) ->
    youTube = presentz.videoPlugin
    youTube.id = id
    youTube.player = $("#" + id)[0]
    youTube.player.addEventListener("onStateChange", "presentz.videoPlugin.video.handleEvent")
    if youTube.wouldPlay
      if not presentz.intervalSet
        presentz.startTimeChecker()
      youTube.player.playVideo()
    return
  
  adjustSize: () ->
    newSize = @sizer.optimalSize()
    player = $("##{@id}")
    if player.width() != newSize.width
      player.width(newSize.width)
      player.height(newSize.height)
    return

  currentTime: () ->
    return @player.getCurrentTime()
    
  skipTo: (time) ->
    if @player
      @player.seekTo(time, true)
      return true
    return false
