class BlipTv

  constructor: (@presentz) ->
    @video = new Video 1, 2, 0, @presentz

  changeVideo: (videoData, @wouldPlay) ->
    movieUrl = "#{videoData.url}.js?width=480&height=303&parent=bliptvcontainer"

    if $("#videoContainer").children().length == 0
      $("#videoContainer").append("<div id='bliptvcontainer'></div>")
      script = document.createElement('script')
      script.type = 'text/javascript'
      script.src = movieUrl
      
      scripts = $("script")
      $(scripts[scripts.length - 1]).append(script)
      console.log $("script")
    else
      throw "boh!"
      #@player.cueVideoByUrl(movieUrl)

    if @wouldPlay and @player != undefined
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
      @player.play()

    return

  videoId = (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://blip.tv") != -1

  onBlipTvPlayerAlmostReady: () ->
    @player = document.getElementById("bliptvcontainer");
    caller = this
    @player.registerCallback("playerReady", `function () {
        caller.onBlipTvPlayerReady();
    }`)
    return
    
  onBlipTvPlayerReady: () ->
    if @wouldPlay
      if not @presentz.intervalSet
        @presentz.startTimeChecker()
      @player.play()

    return
  
  currentTime: () ->
    return presentz.videoPlugin.player.getCurrentTime()
