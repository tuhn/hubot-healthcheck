module.exports = (robot) ->
  healthCheckUrl = 'http://jarvisexchange.sandbox.local/_monitor/health/run'

  attachments = []

  colors =
    success: '#00b200'
    alert: '#e50000'

  concat = (check) ->
    color = if check.status == 0 then colors.success else color.alert
    attachments.push {
      'color': color
      'text': "*#{check.checkName}* \n\n #{check.message}"
    }

  robot.respond /test/i, (msg) ->
    robot.http(healthCheckUrl)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      data = JSON.parse body
      #msg.send "status: #{data.globalStatus}"

      attachments = []
      concat check for check in data.checks

      console.log(JSON.stringify(attachments));

      #msg.send report
      msg.send
        username: "healthCheck Bot",
        mrkdwn: true
        text: "<#{healthCheckUrl}|global status: #{data.globalStatus}>"
        #text: report
        attachments: attachments
