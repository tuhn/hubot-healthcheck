
# Description:
#   Say "World"
#
# Notes:
#


module.exports = (robot) ->
  robot.router.get "/hello", (req, res) ->
    robot.send 'Hello'
    res.writeHead 200, {'Content-type': 'text/plain'}
    res.end 'Hello'
