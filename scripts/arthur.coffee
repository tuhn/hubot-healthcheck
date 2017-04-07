# Description:
#   A way to check the health of our environments
#
# Commands:
#   hubot healtcheck - does a check of all available environments
#   hubot healthcheck <env> - does a check of the specified environment

module.exports = (robot) ->

  urls =
    jarvisexchange: 'http://jarvisexchange.sandbox.local/_monitor/health/run'
    bt2: 'http://bt2.sandbox.local/fr/health_check.php'


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

  robot.respond /healthcheck/i, (msg) ->
    for env, url of urls
      robot.http(url)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send "unable to retrieve the status of #{url}"
        else
          data = JSON.parse body
          attachments = []
          concat check for check in data.checks
          # console.log(JSON.stringify(attachments));

          date = new Date()

          prevStatus = robot.brain.get(env)

          unless prevStatus
            prevStatus = []

          prevStatus.push ({
            status: data.globalStatus
            date: date.toUTCString()
          });

          robot.brain.set(env, prevStatus)

          backup = robot.brain.get(env)

          console.log env
          console.log JSON.stringify prevStatus

          attachments.push {
            title: 'previous status'
            text: JSON.stringify(backup)
          }

          msg.send
            username: "healthCheck Bot",
            mrkdwn: true
            text: "<#{url}|#{data.globalStatus}>"
            attachments: attachments
