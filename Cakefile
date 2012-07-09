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

exec = require("child_process").exec

header = '''
/*
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
*/
'''

task "build", ->
  command = [
    "mkdir -p build"
    "rm -rf build/*"
    "coffee -o build -j PresentzTmp -c src/Video.coffee src/Html5Video.coffee src/Vimeo.coffee src/YoutubeIFrame.coffee src/BlipTv.coffee src/ImgSlide.coffee src/SlideShare.coffee src/SwfSlide.coffee src/Sizer.coffee src/Presentz.coffee"
  ]

  sources = ["PresentzTmp"]
  targets = ["presentz"]

  for i in [0..sources.length - 1]
    command.push "echo '#{ header }' > build/#{targets[i]}.js"
    command.push "cat build/#{sources[i]}.js >> build/#{targets[i]}.js"
    command.push "rm build/#{sources[i]}.js"

  exec command.join(" && "), (err) ->
    throw err if err