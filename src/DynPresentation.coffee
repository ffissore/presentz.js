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

params = window.location.search.substring(1).split("&")
importExternalJS param for param in params when param.indexOf("p=") == 0 && param.length > 2

importExternalJS = (param) ->
  scriptUrl = param.substr(2)

  script = document.createElement('script')
  script.type = 'text/javascript'
  script.src = scriptUrl

  scripts = $("script")
  $(scripts[scripts.length - 1]).append(script);