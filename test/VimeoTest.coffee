assert = require "assert"
Vimeo = require("../src/Vimeo").presentz.Vimeo

class FakeVideo

global.Video = FakeVideo

fake_presentz =
  newElementName: () -> ""

describe "Vimeo URL parsing", () ->
  video = null

  beforeEach () ->
    video = new Vimeo(fake_presentz)

  it "should handle valid URLs", () ->
    assert(video.handle({ url: "http://vimeo.com/48061340" }))
    assert(video.handle({ url: "https://vimeo.com/48061340" }))
    assert(video.handle({ url: "http://vimeo.com/48061340?asdasd" }))
    assert(video.handle({ url: "https://vimeo.com/48061340?asdasd" }))
    assert(!video.handle({ url: "http://www.google.com" }))

  it "should extract video id", () ->
    assert.equal(video.videoId({ url: "http://vimeo.com/48061340" }), "48061340")
    assert.equal(video.videoId({ url: "https://vimeo.com/48061340" }), "48061340")
    assert.equal(video.videoId({ url: "http://vimeo.com/48061340?asdasd" }),"48061340")
    assert.equal(video.videoId({ url: "https://vimeo.com/48061340?asdasd" }),"48061340")
