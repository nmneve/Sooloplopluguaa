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

_ = require('underscore')

module.exports = (robot) ->
  memoriesByRecollection = () -> robot.brain.data.memoriesByRecollection ?= {}
  memories = () -> robot.brain.data.remember ?= {}

  findSimilarMemories = (key) ->
    searchRegex = new RegExp(key, 'i')
    Object.keys(memories()).filter (key) -> searchRegex.test(key)

  robot.respond /(?:what is|rem(?:ember)?)\s+(.*)/i, (msg) ->
    words = msg.match[1]
    if match = words.match /(.*?)(\s+is\s+([\s\S]*))$/i
      msg.finish()
      key = match[1].toLowerCase()
      value = match[3]
      currently = memories()[key]
      if currently
        msg.send "Slop sees that #{key} is already remembered. But that's ok, Splop still likes you."
      else
        memories()[key] = value
        msg.send "OK, Splop will remember #{key}."
    else if match = words.match /([^?]+)\??/i
      msg.finish()

      key = match[1].toLowerCase()
      value = memories()[key]

      if value
        memoriesByRecollection()[key] ?= 0
        memoriesByRecollection()[key]++
      else
        if match = words.match /\|\s*(grep\s+)?(.*)$/i
          searchPattern = match[2]
          matchingKeys = findSimilarMemories(searchPattern)
          if matchingKeys.length > 0
            value = "Splop remember:\n#{matchingKeys.join('\n')}"
          else
            value = "Splop don't remember anything matching `#{searchPattern}`"
        else
          matchingKeys = findSimilarMemories(key)
          if matchingKeys.length > 0
            keys = matchingKeys.join('\n')
            value = "Splop don't remember `#{key}`. Did you mean:\n#{keys}"
          else
            value = "Splop don't remember anything matching `#{key}`"

      msg.send value

  robot.respond /(?:forget|delete|remove?)\s+(.*)/i, (msg) ->
    key = msg.match[1].toLowerCase()
    value = memories()[key]
    delete memories()[key]
    delete memoriesByRecollection()[key]
    msg.send "Ok Splop has forgotten #{key} is #{value}."

  robot.respond /list rules/i, (msg) ->
    msg.finish()
    keys = []
    keys.push key for key of memories()
    msg.send "Splop remember:\n#{keys.join('\n')}"

