module.exports = (robot) ->
  healthCheckUrl = 'http://jarvisexchange.sandbox.local/_monitor/health/run'

  attachments = []

  concat = (check) ->
    icon = if check.status == 0 then '✔' else '✖'
    attachments.push {
      text: icon + ' ' + check.checkName + "\n" + check.message
    }

  robot.respond /test/i, (msg) ->
    robot.http(healthCheckUrl)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      data = JSON.parse body
      #msg.send "status: #{data.globalStatus}"

      concat check for check in data.checks

      console.log(JSON.stringify(attachments));

      #msg.send report
      msg.send
        username: "healthCheck Bot",
        mrkdwn: true
        text: "global status: #{data.globalStatus}"
        #text: report
        attachments: attachments
        #   text: "And here's an attachment!"
        #   image_url: "http://www.freeiconspng.com/uploads/success-icon-10.png"
        # ]
