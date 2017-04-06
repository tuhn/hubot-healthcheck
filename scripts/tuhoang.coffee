
# Description:
#   
#
# Notes:
#


module.exports = (robot) ->
  robot.respond /fuck/i, (msg) ->
    msg.send 'you!'
