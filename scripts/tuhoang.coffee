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

  robot.respond /check (.*)/i, (msg) ->
    envName = msg.match[1]

    if envName of aliases
      envName = aliases[envName]

    if envName in sites
      siteName = envName + '.sandbox.local'

      if envName in jarvisSites
        healthCheckUrl = "http://#{siteName}/_monitor/health/run"
      else
        healthCheckUrl = "http://#{siteName}/fr/health"
      msg.send "Hey, I am trying to check #{healthCheckUrl}. Please wait for a few seconds..."

      robot.http(healthCheckUrl)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        try
          data = JSON.parse body
          attachments = []
          colors =
            success: '#00b200'
            alert: '#e50000'
          for check in data.checks
            attachments.push {
              fallback: check.checkName
              color: if check.status == 0 then colors.success else color.alert
              text: check.message
            }
          msg.send
            text: "General Status: *#{data.globalStatus}*"
            attachments: attachments
        catch err
          msg.send "Sorry, I coudn't check #{healthCheckUrl}"
    else
      msg.send "Sorry, that site has not been defined: *#{envName}*"
