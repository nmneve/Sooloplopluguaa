# Description
#   Reads and writes information to a Yaml file.
#
# Commands:
#   hubot add <key>: <value> - Creates and saves a new rule
#   hubot <key> rules - Posts an existing rule
#   hubot list rules - Lists all the created keys

fs = require "fs"
exec = require('child_process').exec
hubot_home = process.env.HUBOT_HOME

module.exports = (robot) ->
  rulesPath = 'rules.yml'
  rulesFile = fs.readFileSync rulesPath, 'utf-8'
  rulesData = rulesFile.toString().split("\n")

  robot.respond /add (.*): (.*)/i, (msg) ->
    key = msg.match[1].toLowerCase()
    value = msg.match[2]
    isDuplicate = false

    exec 'cd /Sooloplopluguaa && git pull', (error, stdout, stderr) ->
      console.log 'stdout: ' + stdout
      console.log 'stderr: ' + stderr
      if error != null
        console.log 'exec error: ' + error
        msg.send "Uh oh, Splop failed to pull from Github"
        return
      else
        regex = new RegExp(key + ":.*", 'i')

        rulesData.forEach (line) ->
          if line.match regex
            isDuplicate = true

        if isDuplicate
          msg.send "Slop sees that #{key} is already a rule. But that's ok, Splop still likes you."
        else
          fs.appendFileSync rulesPath, "\n#{key}: '#{value}'", 'utf8'

          exec 'cd /Sooloplopluguaa && git add . && git commit -m \"Added new rules\" && git push && git push heroku master', (error, stdout, stderr) ->
            console.log 'stdout: ' + stdout
            console.log 'stderr: ' + stderr
            if error != null
              console.log 'exec error: ' + error
              msg.send "Uh oh, Splop failed to save to Github"
              return 
            else
              msg.send "OK, Splop will remember #{key}."

  robot.respond /(.*) rules/i, (msg) ->
    key = msg.match[1].toLowerCase()
    isFound = false

    regex = new RegExp(key + ":.*", 'i')

    rulesData.forEach (line) ->
      if line.match regex
        msg.send line
        isFound = true

    if !isFound
      msg.send "Splop don't know anything about #{key}"

  # robot.respond /(?:forget|delete|remove?)\s+(.*)/i, (msg) ->
  #   key = msg.match[1].toLowerCase()  
  # msg.send "Ok Splop has forgotten #{key}"

  robot.respond /list rules/i, (msg) ->
    msg.send "Splop remember:"
    rulesData.forEach (line) ->
      keyValue = line.split(":")
      msg.send keyValue[0]
