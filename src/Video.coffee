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

class Video
  
  constructor: (@playState, @pauseState, @finishState, @presentz) ->
  
  handleEvent: (id, event) ->
    if event == @playState
      startTimeChecker()
    else if event == @pauseState or event == @finishState
      stopTimeChecker()
      
    if event == @finishState and chapter < (howManyChapters - 1)
      changeChapter(chapter + 1, true)
