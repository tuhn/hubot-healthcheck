module.exports = (robot) ->
  urls = [
    'http://jarvisexchange.sandbox.local/_monitor/health/run'
    'http://bt2.sandbox.local/fr/health/'
  ]

  attachments = []

  colors =
    check_result_ok: '#00b200'
    check_result_warning: '#ffff00'
    check_result_skip: '#cccccc'
    check_result_critical: '#e50000'

  concat = (check) ->
    attachments.push {
      color: colors[check.status_name]
      title: check.checkName
      text: check.message
      mrkdwn_in:
        "text"
    }

  for url in urls
    robot.respond /test/i, (msg) ->
      robot.http(url)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse body

        attachments = []
        concat check for check in data.checks

        console.log(JSON.stringify(attachments));

        #globalStatus = data.globalStatus.replace(data.globalStatus.replace(/^(global status: )(.*)/i, "$1*$2*"))

        msg.send
          username: "healthCheck Bot",
          mrkdwn: true
          text: "<#{url}|#{data.globalStatus}>"
          attachments: attachments
