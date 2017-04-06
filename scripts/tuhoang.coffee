#
# Description:
#   
#
# Notes:
#

module.exports = (robot) ->

  sites = [
    'pp',
    'preprod',
    'front-pp-u3',
    'jarvisexchange',
    'ben',
    'bt2',
    'mage-buy'
  ]

  aliases =
    pp: 'front-pp-u3'
    preprod: 'front-pp-u3'

  robot.respond /check (.*)/i, (msg) ->    
    envName = msg.match[1]

    if envName of aliases
      envName = aliases[envName]

    if envName in sites
      siteName = envName + '.sandbox.local'
      healthCheckUrl = 'http://' + siteName + '/_monitor/health/run'

      msg.send "Hey, I am trying to check " + siteName
      robot.http(healthCheckUrl)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        try
          data = JSON.parse body
          msg.send
            text: "General Status: #{data.globalStatus}"
            attachments: [
              {
                fallback: 'EAI Accessibility Check'
                color: '#00b200'
                text: 'EAI is OK'
              }
              {
                fallback: 'MemcacheD Accessibility Check'
                color: '#00b200'
                text: 'MemcacheD is OK'
              }
            ]
        catch err
          msg.send "Sorry, I coudn't check " + siteName
    else
      msg.send "Sorry, that site has not been defined: " + envName
