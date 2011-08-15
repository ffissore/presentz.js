class Vimeo

  constructor: (presentz) ->
    @video = new Video "play", "pause", "finish", presentz
    @wouldPlay = false
    @currentTimeInSeconds = 0.0

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
    movieUrl = "http://player.vimeo.com/video/#{ videoId(@videoData) }?api=1&player_id=player_1"

    if $("#videoContainer").children().length == 0
      videoHtml = "<iframe id='player_1' src='#{ movieUrl }' width='100%' height='#{ data[0].height }' frameborder='0'></iframe>"
      $("#videoContainer").append(videoHtml)
      iframe = $("#videoContainer iframe")[0]
      caller = this
      onReady = `function(id) {
        caller.onReady(id);
      }`
      $f(iframe).addEvent("ready", onReady)
    else
      iframe = $("#videoContainer iframe")[0]
      iframe.src = movieUrl

    return

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://vimeo.com") != -1

  onReady: (id) ->
    video = $f(id)
    caller = this
    video.addEvent("play", `function() {
      caller.video.handleEvent("play");
    }`)
    video.addEvent("pause", `function() {
      caller.video.handleEvent("pause");
    }`)
    video.addEvent("finish", `function() {
      caller.video.handleEvent("finish");
    }`)
    video.addEvent("playProgress", `function(data) {
      caller.currentTimeInSeconds = data.seconds;
    }`)
    return

  currentTime: () ->
    return @currentTimeInSeconds