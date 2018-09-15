'use strict'

// Description
//   hubot scripts for diagnosing hubot
//
// Commands:
//   hubot ping - Reply with pong
// Author:
//   Josh Nichols <technicalpickles@github.com>

module.exports = function (robot) {
  robot.respond(/PING$/i, msg => {
    msg.send('PONG')
  })
}
