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

class Html5Video

  changeVideo: (videoData, play) ->
    if $("#videoContainer").children().length == 0
      videoHtml = "<video controls preload='none' src='#{ videoData.url }' width='100%' heigth='100%'></video>"
      $("#videoContainer").append(videoHtml)

      video = $("#videoContainer > video")[0]
      video.addEventListener("play", handleEvent, false)
      video.addEventListener("pause", handleEvent, false)
      video.addEventListener("ended", handleEvent, false)
    else
      video = $("#videoContainer > video")[0]
      video.setAttribute("src", videoData.url)
