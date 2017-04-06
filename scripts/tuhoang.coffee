#
# Description:
#   
#
# Notes:
#

module.exports = (robot) ->
  sites = [
    'jarvisexchange',
    'ben',
    'bt2',
    'mage-buy'
  ]  
  robot.respond /check (.*)/i, (msg) ->    
    envName = msg.match[1]
    if envName in sites
      healthCheckUrl = 'http://' + envName + '.sandbox.local/_monitor/health/run'
      msg.send "Hey, I am trying to check " + healthCheckUrl
      robot.http(healthCheckUrl)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        try
          data = JSON.parse body
          msg.send "General Status: #{data.globalStatus}"
        catch err
          msg.send "Sorry, I coudn't check " + healthCheckUrl
    else
      msg.send "Sorry, that site has not been defined!"

