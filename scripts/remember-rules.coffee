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

  robot.respond /create (.*) rule: (.*)/i, (msg) ->
    key = msg.match[1].toLowerCase()
    value = msg.match[2]
    isDuplicate = false

    rulesData = rulesFile.toString().split("\n")

    regex = new RegExp(key + ":.*", 'i')

    rulesData.forEach (line) ->
      if line.match regex
        isDuplicate = true

    if isDuplicate
      msg.send "Slop sees that #{key} is already a rule. But that's ok, Splop still likes you."
    else
      fs.appendFileSync rulesPath, "\n#{key}: '#{value}'", 'utf8'
      msg.send "OK, Splop will remember #{key}."

  # robot.respond /forget\s+(.*)/i, (msg) ->
  #   key = msg.match[1].toLowerCase()
  #   value = memories()[key]
  #   delete memories()[key]
  #   delete memoriesByRecollection()[key]
  #   msg.send "Ok Splop has forgotten #{key} is #{value}."

  # robot.respond /what do you remember/i, (msg) ->
  #   msg.finish()
  #   keys = []
  #   keys.push key for key of memories()
  #   msg.send "Splop remember:\n#{keys.join('\n')}"

  #   msg.send "My favorite memories are:\n#{sortedMemories[0..20].join('\n')}"
