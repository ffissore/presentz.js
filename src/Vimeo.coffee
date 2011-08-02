class Vimeo extends Video

	constructor: () ->
		super("play", "pause", "finish")
		@wouldPlay = false
		
	changeVideo: (videoData, play) ->
		movieUrl = "http://vimeo.com/moogaloop.swf?clip_id=#{ videoData.url.substr(videoData.url.lastIndexOf("/") + 1) }"
		
		$("#videoContainer").empty();
		$("#videoContainer").append("<div id='vimeoContainer'></div>");
		
		params = 
			allowscriptaccess : "always"
			flashvars : "api=1&player_id=vimeoplayer&api_ready=video.onPlayerReady&js_ready=video.onPlayerReady"
		
		atts = 
			id : "vimeoplayer"
		
		swfobject.embedSWF(movieUrl, "vimeoContainer", "425", "356", "8", null, null, params, atts)
		wouldPlay = play;
		
	onPlayerReady: (id) ->
		video = document.getElementById(id)
		video.api_addEventListener("play", "video.handleVideoEvent")
		video.api_addEventListener("pause", "video.handleVideoEvent")
		video.api_addEventListener("finish", "video.handleVideoEvent")
		
		if wouldPlay
			wouldPlay = false
			
			if not intervalSet
				startTimeChecker()
			
			video.api_play();
