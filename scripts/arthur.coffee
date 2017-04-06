module.exports = (robot) ->
  healthCheckUrl = 'http://jarvisexchange.sandbox.local/_monitor/health/run'
  robot.respond /test/i, (msg) ->
    robot.http(healthCheckUrl)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      data = JSON.parse body
      res.send "status: #{data.globalStatus}"
