# Description
#   Remembers a key and value
#
# Commands:
#   hubot what is|remember <key> - Returns a string
#   hubot remember <key> is <value>. - Returns nothing. Remembers the text for next time!
#   hubot what do you remember - Returns everything hubot remembers.
#   hubot forget <key> - Removes key from hubots brain.
#   hubot what are your favorite memories? - Returns a list of the most remembered memories.  
#   hubot random memory - Returns a random string
#
# Dependencies:
#   "underscore": "*"

fs = require "fs"
exec = require('child_process').exec
request = require('request')

module.exports = (robot) ->
  rulesPath = 'rules.yml'
  rulesFile = fs.readFileSync rulesPath, 'utf-8'
  rulesData = rulesFile.toString().split("\n")

  robot.respond /create (.*) rule: (.*)/i, (msg) ->
    key = msg.match[1].toLowerCase()
    value = msg.match[2]
    isDuplicate = false

    regex = new RegExp(key + ":.*", 'i')

    rulesData.forEach (line) ->
      if line.match regex
        isDuplicate = true

    if isDuplicate
      msg.send "Slop sees that #{key} is already a rule. But that's ok, Splop still likes you."
    else
      fs.appendFileSync rulesPath, "\n#{key}: '#{value}'", 'utf8'
      msg.send "OK, Splop will remember #{key}."

  robot.respond /(.*) rule/i, (msg) ->
    key = msg.match[1].toLowerCase()

    regex = new RegExp(key + ":.*", 'i')

    rulesData.forEach (line) ->
      if line.match regex
        msg.send line

  # robot.respond /(?:forget|delete|remove?)\s+(.*)/i, (msg) ->
  #   key = msg.match[1].toLowerCase()  
  # msg.send "Ok Splop has forgotten #{key}"

  robot.respond /list rules/i, (msg) ->
    msg.send "Splop remember:"
    rulesData.forEach (line) ->
      keyValue = line.split(":")
      msg.send keyValue[0]
