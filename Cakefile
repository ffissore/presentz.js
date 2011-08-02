exec = require('child_process').exec

task 'build', ->
  exec 'coffee -o lib -j Presentz.js -c src/*.coffee', (err) ->
    console.log err if err
