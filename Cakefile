exec = require("child_process").exec
assert = require("assert")

task "build", ->
  exec [
    "mkdir -p dist"
    "rm -rf dist/*"
    "coffee -o dist -j presentz_tmp -c src/strict.coffee src/Video.coffee src/Html5Video.coffee src/Vimeo.coffee src/Youtube.coffee src/BlipTv.coffee src/ImgSlide.coffee src/SlideShare.coffee src/SlideShareByImage.coffee src/SwfSlide.coffee src/SpeakerDeck.coffee src/IFrameSlide.coffee src/Presentz.coffee"
    "echo '/*' >> dist/presentz.js"
    "cat LICENSE_SHORT >> dist/presentz.js"
    "echo '*/' >> dist/presentz.js"
    "cat dist/presentz_tmp.js >> dist/presentz.js"
    "rm dist/presentz_tmp.js"
    "node_modules/uglify-js/bin/uglifyjs -o dist/presentz.min.js dist/presentz.js"
    "mv dist/presentz.js dist/presentz-1.1.2.js"
    "mv dist/presentz.min.js dist/presentz-1.1.2.min.js"
  ].join " && ", (err) ->
    assert !err?, err