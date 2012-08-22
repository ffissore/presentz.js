class Youtube

  constructor: (@presentz, @videoContainer, @width, @height) ->
    @video = new Video 1, 2, 0, @presentz
    if window.onYouTubePlayerReady
      errorMessage = "There already is a 'onYouTubePlayerReady' global function defined: presentz.js needs to define its own in order to display this presentation"
      alert(errorMessage)
      throw new Error(errorMessage)
    window.onYouTubePlayerReady = @onYouTubePlayerReady

  changeVideo: (videoData, @wouldPlay) ->
    movieUrl = "http://www.youtube.com/e/#{videoId(videoData)}?enablejsapi=1&autohide=1&fs=1&playerapiid=ytplayer"

    if jQuery(@videoContainer).children().length is 0
      jQuery(@videoContainer).append("<div id=\"youtubecontainer\"></div>")
      params =
        allowScriptAccess: "always"
        allowFullScreen: true
        wmode: "opaque"
      atts =
        id: "ytplayer"

      swfobject.embedSWF(movieUrl, "youtubecontainer", @width, @height, "8", null, null, params, atts)
    else
      @player.cueVideoByUrl(movieUrl)

    if @wouldPlay and @player?
      if !@presentz.intervalSet
        @presentz.startTimeChecker()
      @player.playVideo()

    return

  videoId= (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  handle: (presentation) ->
    presentation.chapters[0].video.url.toLowerCase().indexOf("http://youtu.be") != -1

  onYouTubePlayerReady: (id) ->
    youTube = presentz.videoPlugin
    youTube.id = id
    youTube.player = jQuery("#" + id)[0]
    youTube.player.addEventListener("onStateChange", "presentz.videoPlugin.video.handleEvent")
    if youTube.wouldPlay
      if !presentz.intervalSet
        presentz.startTimeChecker()
      youTube.player.playVideo()
    return

  currentTime: () ->
    @player.getCurrentTime()

  skipTo: (time, wouldPlay = false) ->
    if @player
      @player.seekTo(time, true)
      @player.playVideo() if wouldPlay
      true
    false
