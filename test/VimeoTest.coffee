assert = require "assert"
Vimeo = require("../src/Vimeo").presentz.Vimeo

class FakeVideo

global.Video = FakeVideo

fake_presentz =
  newElementName: () -> ""

describe "URL parsing", () ->
  vimeo = null

  beforeEach () ->
    vimeo = new Vimeo(fake_presentz)

  it "should handle valid URLs", () ->
    assert(vimeo.handle({ url: "http://vimeo.com/48061340" }))
    assert(vimeo.handle({ url: "https://vimeo.com/48061340" }))
    assert(vimeo.handle({ url: "http://vimeo.com/48061340?asdasd" }))
    assert(vimeo.handle({ url: "https://vimeo.com/48061340?asdasd" }))

  it "should extract correct video id", () ->
    assert.equal(vimeo.videoId({ url: "http://vimeo.com/48061340" }), "48061340")
    assert.equal(vimeo.videoId({ url: "https://vimeo.com/48061340" }), "48061340")
    assert.equal(vimeo.videoId({ url: "http://vimeo.com/48061340?asdasd" }),"48061340")
    assert.equal(vimeo.videoId({ url: "https://vimeo.com/48061340?asdasd" }),"48061340")
