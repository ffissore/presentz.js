class Youtube

  constructor: (@presentz) ->
    @video = new Video 1, 2, 0, @presentz
    window.onYouTubePlayerReady = @onYouTubePlayerReady

  changeVideo: (videoData, @wouldPlay) ->
    movieUrl = "http://www.youtube.com/e/#{ videoId(videoData) }?enablejsapi=1&playerapiid=ytplayer"

    if $("#videoContainer").children().length == 0
      $("#videoContainer").append("<div id='youtubecontainer'></div>")
      params =
        allowScriptAccess : "always"
      atts = 
        id : "ytplayer"
      
      swfobject.embedSWF(movieUrl, "youtubecontainer", "425", "356", "8", null, null, params, atts);
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
    presentz.videoPlugin.playerArray = $("#" + id)
    presentz.videoPlugin.player = presentz.videoPlugin.playerArray[0]
    presentz.videoPlugin.player.addEventListener("onStateChange", "presentz.videoPlugin.video.handleEvent")
    adjustVideoSize(presentz.videoPlugin.playerArray)
    if presentz.videoPlugin.wouldPlay
      if not presentz.intervalSet
        presentz.startTimeChecker()
      presentz.videoPlugin.player.playVideo()

    return
  
  adjustVideoSize = (playerArray) ->
    newWidth = $("#videoContainer").width() #- ($("#videoContainer").width() / 100 * 20)
    newHeight = 0.837647059 * newWidth
    playerArray.width(newWidth)
    playerArray.height(newHeight)
    return

  currentTime: () ->
    return presentz.videoPlugin.player.getCurrentTime()
    
  skipTo: (time) ->
    return false
