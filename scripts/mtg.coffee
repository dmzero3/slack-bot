module.exports = (robot) ->
  robot.respond /mtg/i, (msg) ->
    msg.send 'ミーティングしましょう'
