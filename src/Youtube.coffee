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
    	
    	#$("#videoContainer").css("padding", "0px")
    else
    	video = $("#ytplayer")[0]
    	video.cueVideoByUrl(movieUrl)

    if @wouldPlay and $("#ytplayer").length > 0
    	if not @presentz.intervalSet
    		@presentz.startTimeChecker()
    	$("#ytplayer")[0].playVideo()

    return

  videoId = (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://youtu.be") != -1

  onYouTubePlayerReady: (id) ->
  	$("#" + id)[0].addEventListener("onStateChange", "presentz.videoPlugin.video.handleEvent")
  	adjustVideoSize(id)
  	if presentz.videoPlugin.wouldPlay
  		if not presentz.intervalSet
  			presentz.startTimeChecker()
  		$("#" + id)[0].playVideo()

    return
  
  adjustVideoSize = (id) ->
  	newWidth = $("#videoContainer").width() #- ($("#videoContainer").width() / 100 * 20)
  	newHeight = 0.837647059 * newWidth
  	player = $("#" + id)
  	player.width(newWidth)
  	player.height(newHeight)
  	return

  currentTime: () ->
    return $("#ytplayer")[0].getCurrentTime()
