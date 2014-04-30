assert = require "assert"
SambatechPlugin = require("../src/SambatechPlugin").presentz.SambatechPlugin

class FakeVideo

global.Video = FakeVideo

fake_presentz =
  newElementName: () -> ""

describe "SambatechPlugin URL parsing", () ->
  video = null

  beforeEach () ->
    video = new SambatechPlugin(fake_presentz)

  it "should handle valid URLs", () ->
    assert(video.handle({ url: "http://player.sambatech.com.br/current/samba-player.js?ph=1848c0c4b30b5d2d886ef99546152c23&m=449ead8b6768bb8ec73a8ef579d175f3" }))
    assert(video.handle({ url: "http://player.sambatech.com.br/current/samba-player.js?ph=1848c0c4b30b5d2d886ef99546152c23&m=449ead8b6768bb8ec73a8ef579d175f3&asdf=asdf" }))
    assert(!video.handle({ url: "http://www.google.com" }))

  it "should extract video id", () ->
    assert.equal(video.videoId({ url: "http://player.sambatech.com.br/current/samba-player.js?ph=1848c0c4b30b5d2d886ef99546152c23&m=449ead8b6768bb8ec73a8ef579d175f3" }), "449ead8b6768bb8ec73a8ef579d175f3")
    assert.equal(video.videoId({ url: "http://player.sambatech.com.br/current/samba-player.js?ph=1848c0c4b30b5d2d886ef99546152c23&m=449ead8b6768bb8ec73a8ef579d175f3&asdf=asdf" }), "449ead8b6768bb8ec73a8ef579d175f3")

  it "should extract player key", () ->
    assert.equal(video.playerKey({ url: "http://player.sambatech.com.br/current/samba-player.js?ph=1848c0c4b30b5d2d886ef99546152c23&m=449ead8b6768bb8ec73a8ef579d175f3" }), "1848c0c4b30b5d2d886ef99546152c23")
    assert.equal(video.playerKey({ url: "http://player.sambatech.com.br/current/samba-player.js?ph=1848c0c4b30b5d2d886ef99546152c23&m=449ead8b6768bb8ec73a8ef579d175f3&asdf=asdf" }), "1848c0c4b30b5d2d886ef99546152c23")
