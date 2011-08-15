class Vimeo

  constructor: (presentz) ->
    @video = new Video "play", "pause", "finish", presentz
    @wouldPlay = false

  changeVideo: (@videoData, @wouldPlay) ->
    ajaxCall =
      url: "http://vimeo.com/api/v2/video/#{ videoId(@videoData) }.json"
      dataType: "jsonp"
      jsonpCallback: "presentz.videoPlugin.receiveVideoInfo"

    $.ajax ajaxCall
    return

  videoId = (videoData) ->
    videoData.url.substr(videoData.url.lastIndexOf("/") + 1)

  receiveVideoInfo: (data) ->
    movieUrl = "http://player.vimeo.com/video/#{ videoId(@videoData) }?api=1"

    if $("#videoContainer").children().length == 0
      videoHtml = "<iframe src='#{ movieUrl }' width='100%' height='#{ data[0].height }' frameborder='0'></iframe>"
      $("#videoContainer").append(videoHtml)
      iframe = $("#videoContainer iframe")[0]
      $f(iframe).addEvent("ready", presentz.videoPlugin.onPlayerReady)
    else
      iframe = $("#videoContainer iframe")[0]
      iframe.src = movieUrl

    return

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://vimeo.com") != -1

  handleVideoEvent: (event) ->
    console.log event

  onPlayerReady: (id) ->
    video = $f($("#videoContainer iframe")[0])
    video.addEvent("play", presentz.videoPlugin.handleVideoEvent)
    video.addEvent("pause", presentz.videoPlugin.handleVideoEvent)
    video.addEvent("finish", presentz.videoPlugin.handleVideoEvent)

    if @wouldPlay
      wouldPlay = false
      
      if not intervalSet
        startTimeChecker()
      
      video.play()
