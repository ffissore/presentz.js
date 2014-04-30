exec = require("child_process").exec
assert = require("assert")

version = require("./package.json").version

task "build", ->
  exec [
    "mkdir -p dist"
    "rm -rf dist/*"
    "coffee -o dist -j presentz_tmp.js -c strict.coffee src/SambatechPlugin.coffee src/WistiaPlugin.coffee src/Video.coffee src/Html5Video.coffee src/Vimeo.coffee src/Youtube.coffee src/BlipTv.coffee src/ImgSlide.coffee src/SlideShare.coffee src/SlideShareOEmbed.coffee src/SwfSlide.coffee src/SpeakerDeck.coffee src/IFrameSlide.coffee src/RvlIO.coffee src/NoSlide.coffee src/Presentz.coffee"
    "echo '/*' >> dist/presentz.js"
    "cat LICENSE_SHORT >> dist/presentz.js"
    "echo '*/' >> dist/presentz.js"
    "cat dist/presentz_tmp.js >> dist/presentz.js"
    "rm dist/presentz_tmp.js"
    "node_modules/uglify-js/bin/uglifyjs -o dist/presentz.min.js dist/presentz.js"
    "mv dist/presentz.js dist/presentz-#{version}.js"
    "mv dist/presentz.min.js dist/presentz-#{version}.min.js"
    "sed -i 's/presentz-[0-9].[0-9].[0-9]/presentz-#{version}/g' examples/*.html"
  ].join " && ", (err) ->
    assert !err?, err
