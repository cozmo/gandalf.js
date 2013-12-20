mocha = require "mocha"
assert = require "assert"
fs = require "fs"
jsdom = require("jsdom").jsdom

describe "gandalf", ->
  window = null

  before (done) ->
    jsdom.env
      html:fs.readFileSync("#{__dirname}/page_specs/index.html").toString()
      src: [
        fs.readFileSync("#{__dirname}/page_specs/jquery-1.8.3.min.js").toString()
        fs.readFileSync("#{__dirname}/../dist/gandalf.js").toString()
      ]
      done: (errors, _window) ->
        window = _window
        done()

  it "is a jquery plugin", ->
    assert.equal window.jQuery().gandalf?,true

  it "expects a callback", ->
    assert.throws (->
      window.jQuery().gandalf()
    ), /gandalf.js expects a callback/

  it "executes the callback when operating elements with no validators", (done) ->
    $results = window.jQuery("#no_validators").gandalf(
      callback: (errors) ->
        assert true, "callback called"
        done()
    )

    it "throws an error when it has no matching validators", ->
    assert.throws (->
      window.jQuery("#bad_validator").gandalf(
        callback: () ->
      )
    ),/gandalf.js couldn't find any validators with name 'bad'/

  it "is chainable", ->
    $results = window.jQuery("#exists").gandalf({callback:()->}).addClass("tested")
    assert window.jQuery("#exists").hasClass("tested"),"element did not get the css class"

  it "throws an error when it has no matching validators", ->
    assert.throws (->
      window.jQuery("#bad_validator").gandalf(
        callback: () ->
      )
    ),/gandalf.js couldn't find any validators with name 'bad'/

  it "default validators work",(done) ->
    window.jQuery("#default_validators input").gandalf(
      callback: (errors) ->
        for error in errors
          if error.errors.length isnt 0
            error.input.addClass "failed"
          else
            error.input.addClass "passed"
        window.jQuery("#default_validators input").each () ->
          if window.jQuery(@).hasClass 'fail'
            assert window.jQuery(@).hasClass('failed'),"input with value '#{window.jQuery(@).val()}' passed validators:#{window.jQuery(@).data('validators')}"
          else if window.jQuery(@).hasClass 'pass'
            assert window.jQuery(@).hasClass('passed'),"input with value '#{window.jQuery(@).val()}' failed validators:#{window.jQuery(@).data('validators')}"
        done()
    )

  it "custom attributes are supported",(done) ->
    window.jQuery("#custom_attributes input").gandalf(
      attribute:"custom-validators"
      callback: (errors) ->
        for error in errors
          if error.errors.length isnt 0
            error.input.addClass "failed"
          else
            error.input.addClass "passed"
        window.jQuery("#default_validators input").each () ->
          if window.jQuery(@).hasClass 'fail'
            assert window.jQuery(@).hasClass('failed'),"input with value '#{window.jQuery(@).val()}' passed validators:#{window.jQuery(@).data('custom-validators')}"
          else if window.jQuery(@).hasClass 'pass'
            assert window.jQuery(@).hasClass('passed'),"input with value '#{window.jQuery(@).val()}' failed validators:#{window.jQuery(@).data('custom-validators')}"
        done()
    )

  it "custom validators are supported",(done) ->
    assert.throws (->
      window.jQuery("#custom_validators input").gandalf(
        callback: (errors) ->
      )
    )
    assert.doesNotThrow (->
      window.jQuery("#custom_validators input").gandalf(
        validators:
          is_foobar:() -> (value, cb) ->
            err = if value isnt "foobar" then "The value isn't 'foobar'." else null
            cb err
        callback: (errors) ->
          for error in errors
            if error.errors.length isnt 0
              error.input.addClass "failed"
            else
              error.input.addClass "passed"
          window.jQuery("#custom_validators input").each () ->
            if window.jQuery(@).hasClass 'fail'
              assert window.jQuery(@).hasClass('failed'),"input with value '#{window.jQuery(@).val()}' passed validators:#{window.jQuery(@).data('validators')}"
            else if window.jQuery(@).hasClass 'pass'
              assert window.jQuery(@).hasClass('passed'),"input with value '#{window.jQuery(@).val()}' failed validators:#{window.jQuery(@).data('validators')}"
          done()
      )
    )
