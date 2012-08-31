assert = require "assert"
Youtube = require("../src/Youtube").presentz.Youtube

class FakeVideo

global.Video = FakeVideo

fake_presentz =
  newElementName: () -> ""

describe "Youtube URL parsing", () ->
  video = null

  beforeEach () ->
    video = new Youtube(fake_presentz)

  it "should handle valid URLs", () ->
    assert(video.handle({ url: "http://youtu.be/eBktyyaV9LY" }))
    assert(video.handle({ url: "https://youtu.be/eBktyyaV9LY" }))
    assert(video.handle({ url: "http://youtu.be/eBktyyaV9LY?feature=youtu.be" }))
    assert(video.handle({ url: "https://youtu.be/eBktyyaV9LY?feature=youtu.be" }))
    assert(video.handle({ url: "http://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }))
    assert(video.handle({ url: "https://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }))
    assert(!video.handle({ url: "http://www.google.com" }))

  it "should extract video id", () ->
    assert.equal(video.videoId({ url: "http://youtu.be/eBktyyaV9LY" }), "eBktyyaV9LY")
    assert.equal(video.videoId({ url: "https://youtu.be/eBktyyaV9LY" }), "eBktyyaV9LY")
    assert.equal(video.videoId({ url: "http://youtu.be/eBktyyaV9LY?feature=youtu.be" }),"eBktyyaV9LY")
    assert.equal(video.videoId({ url: "https://youtu.be/eBktyyaV9LY?feature=youtu.be" }),"eBktyyaV9LY")
    assert.equal(video.videoId({ url: "http://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }), "eBktyyaV9LY")
    assert.equal(video.videoId({ url: "https://www.youtube.com/watch?v=eBktyyaV9LY&feature=youtu.be" }), "eBktyyaV9LY")
