cron = require('cron').CronJob

module.exports = (robot) ->

  cronMorningMtg = new cron('0 00 14 * * 1-5', () =>
    envelope = room: 'room name'
    robot.send envelope, 'message'
  )
  cronMorningMtg.start();

  new cron '0 00 14 * * 1-5', () =>
    robot.send '朝会やりますよ'
  , null, true, "Asia/Tokyo"
