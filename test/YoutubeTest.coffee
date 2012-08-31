assert = require "assert"
Youtube = require("../src/Youtube").Youtube

class FakeVideo

global.Video = FakeVideo

fake_presentz =
  newElementName: () -> ""

describe "URL parsing", () ->
  yt = null

  beforeEach () ->
    yt = new Youtube(fake_presentz)

  it "should handle valid URLs", () ->
    assert(yt.handle({ url: "http://youtu.be/eBktyyaV9LY" }), "http://youtu.be/eBktyyaV9LY")
    assert(yt.handle({ url: "https://youtu.be/eBktyyaV9LY" }), "http://youtu.be/eBktyyaV9LY")
    assert(yt.handle({ url: "http://youtu.be/eBktyyaV9LY?feature=youtu.be" }), "http://youtu.be/eBktyyaV9LY?feature=youtu.be")
    assert(yt.handle({ url: "https://youtu.be/eBktyyaV9LY?feature=youtu.be" }), "http://youtu.be/eBktyyaV9LY?feature=youtu.be")
    assert(yt.handle({ url: "http://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }), "http://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be")
    assert(yt.handle({ url: "https://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }), "http://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be")

  it "should extract correct video id", () ->
    assert.equal(yt.videoId({ url: "http://youtu.be/eBktyyaV9LY" }), "eBktyyaV9LY")
    assert.equal(yt.videoId({ url: "https://youtu.be/eBktyyaV9LY" }), "eBktyyaV9LY")
    assert.equal(yt.videoId({ url: "http://youtu.be/eBktyyaV9LY?feature=youtu.be" }),"eBktyyaV9LY")
    assert.equal(yt.videoId({ url: "https://youtu.be/eBktyyaV9LY?feature=youtu.be" }),"eBktyyaV9LY")
    assert.equal(yt.videoId({ url: "http://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }), "eBktyyaV9LY")
    assert.equal(yt.videoId({ url: "https://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }), "eBktyyaV9LY")
