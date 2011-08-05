###
Presents - A web library to show video/slides presentations

Copyright (C) 2011 Federico Fissore

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

class Vimeo extends Video

  constructor: () ->
    super("play", "pause", "finish")
    @wouldPlay = false

  handle: (presentation) ->
    presentation.chapters[0].media.video.url.toLowerCase().indexOf("http://vimeo.com") != -1

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
