assert = require "assert"
WistiaPlugin = require("../src/WistiaPlugin").presentz.WistiaPlugin

class FakeVideo

global.Video = FakeVideo

fake_presentz =
  newElementName: () -> ""

describe "WistiaPlugin URL parsing", () ->
  video = null

  beforeEach () ->
    video = new WistiaPlugin(fake_presentz)

  it "should handle valid URLs", () ->
    assert(video.handle({ url: "http://www.wistia.com/g3q48tbnyg" }))
    assert(video.handle({ url: "http://www.wistia.com/g3q48tbnyg?asdf=asdf" }))
    assert(!video.handle({ url: "http://www.google.com" }))

  it "should extract video id", () ->
    assert.equal(video.videoId({ url: "http://www.wistia.com/g3q48tbnyg" }), "g3q48tbnyg")
    assert.equal(video.videoId({ url: "http://www.wistia.com/g3q48tbnyg?asdf=asdf" }), "g3q48tbnyg")
