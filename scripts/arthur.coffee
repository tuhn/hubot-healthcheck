module.exports = (robot) ->
  healthCheckUrl = 'http://jarvisexchange.sandbox.local/_monitor/health/run'
  robot.respond /test/i, (msg) ->
    robot.http(healthCheckUrl)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      data = JSON.parse body
      #msg.send "status: #{data.globalStatus}"

      attachment =
        title: "status: #{data.globalStatus}"
        title_link: healthCheckUrl
        fields: [
          {
            title: "Status"
            value: "#{data.globalStatus}"
            short: true
          }
        ]
        color: "#00b200"
        author_icon: "http://www.freeiconspng.com/free-images/success-icon-23194"

      msg.robot.adapter.customMessage
        channel: msg.envelope.room
        username: msg.robot.name
        attachments: [attachment]
