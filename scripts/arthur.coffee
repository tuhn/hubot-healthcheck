module.exports = (robot) ->
  healthCheckUrl = 'http://jarvisexchange.sandbox.local/_monitor/health/run'

  attachments = []

  colors =
    success: '#00b200'
    alert: '#e50000'

  concat = (check) ->
    attachments.push {
      color: if check.status == 0 then colors.success else color.alert
      title: check.checkName
      text: check.message
      mrkdwn_in:
        "text"
    }

  robot.respond /test/i, (msg) ->
    robot.http(healthCheckUrl)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      data = JSON.parse body

      attachments = []
      concat check for check in data.checks

      console.log(JSON.stringify(attachments));

      globalStatus = data.globalStatus.replace(data.globalStatus.replace(/^(global status: )(.*)/i, "$1*$2*"))

      msg.send
        username: "healthCheck Bot",
        mrkdwn: true
        text: "<#{healthCheckUrl}|global status: #{globalStatus}>"
        attachments: attachments
