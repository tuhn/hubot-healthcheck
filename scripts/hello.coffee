
# Description:
#   Say "World"
#
# Notes:
#


module.exports = (robot) ->
  robot.respond /hello/i, (msg) ->
    msg.send 'World!'
