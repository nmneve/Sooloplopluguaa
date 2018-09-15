# Description:
#   Allows Hubot to roll dice
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot roll <x>d<y>([+-]<z>) - roll x dice, each of which has y sides with a modifier
#
# Author:
#   ab9,apowers,rjanardhana,nmneve

module.exports = (robot) ->
  robot.respond /roll (\d+)d(\d+)([+-]\d+)?/i, (msg) ->
    dice = parseInt msg.match[1]
    sides = parseInt msg.match[2]
    modifier = if msg.match[3]? then parseInt msg.match[3] else null

    answer = if sides < 1
      "I don't know how to roll a zero-sided die."
    else
      report (roll dice, sides), modifier
    msg.reply answer

  report = (results, modifier) ->
    if results?
      switch results.length
        when 0
          "I didn't roll any dice."
        when 1
          if modifier?
            total = results[0] + modifier
            "I rolled a #{results[0]} + #{modifier}, making #{total}."
          else
            "I rolled a #{results[0]}."
        else
          total = (results.reduce (x, y) -> x + y)
          if modifier?
              total += modifier
          finalComma = if (results.length > 2) then "," else ""
          last = results.pop()
          if modifier?
            "I rolled #{results.join(", ")}#{finalComma} and #{last} + #{modifier}, making #{total}."
          else
            "#{total}\n(#{results.join(", ")}#{finalComma} #{last})"

  roll = (dice, sides) ->
    rollOne(sides) for i in [0...dice]

  rollOne = (sides) ->
    1 + Math.floor(Math.random() * sides)