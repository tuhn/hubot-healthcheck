#
# Description:
#
#
# Notes:
#

module.exports = (robot) ->
  # allowed sites
  sites = [
    'pp',
    'preprod',
    'front-pp-u3',
    'jarvisexchange',
    'ben',
    'bt2',
    'mage-buy'
  ]
  # for shortcut
  aliases =
    pp: 'front-pp-u3'
    preprod: 'front-pp-u3'
  # jarvis sites have different health check URLs
  jarvisSites = [
    'jarvisexchange'
  ]

  colors =
    check_result_ok: '#00b200'
    check_result_warning: '#ffff00'
    check_result_skip: '#cccccc'
    check_result_critical: '#e50000'
  
  getStatusColor = (status) ->
    if colors[status]?
      return colors[status]
    else
      return '#cccccc'

  robot.respond /check (.*)/i, (msg) ->
    envName = msg.match[1]

    if envName of aliases
      envName = aliases[envName]

    if envName in sites
      siteName = envName + '.sandbox.local'

      if envName in jarvisSites
        healthCheckUrl = "http://#{siteName}/_monitor/health/run"
      else
        healthCheckUrl = "http://#{siteName}/fr/health_check.php?time=" + new Date().getTime()
      msg.send "Hey, I am trying to check *#{siteName}*. Please wait for a few seconds..."
      console.log(healthCheckUrl)

      robot.http(healthCheckUrl)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        try
          data = JSON.parse body
          attachments = []
          for check in data.checks
            attachments.push {
              fallback: check.checkName
              color: getStatusColor(check.status_name)
              text: check.message
            }
          msg.send
            text: "General Status: *#{data.globalStatus}*"
            attachments: attachments
        catch err
          msg.send "Sorry, I coudn't check #{healthCheckUrl}"
          console.log(err)
    else
      msg.send "Sorry, that site has not been defined: *#{envName}*"
