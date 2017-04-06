module.exports = (robot) ->
  healthCheckUrl = 'http://jarvisexchange.sandbox.local/_monitor/health/run'
  robot.respond /test/i, (msg) ->
    robot.http(healthCheckUrl)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      data = JSON.parse body
      # msg.send "status: #{data.globalStatus}"

      msg.send 
        text: "status: #{data.globalStatus}"
        attachments: [
          text: "And here's an attachment!"
          image_url: "http://www.freeiconspng.com/uploads/success-icon-10.png"
        ]
