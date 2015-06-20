# Description:
#   Schedule queries an iCalendar feed to report on upcoming events
#
# Dependencies:
#   "ical"
#
# Configuration:
#   None
#
# Commands:
#   hubot schedule today - Find out what events are scheduled for today
ical = require 'ical'

showSchedule = (msg, limit = null) ->
  msg.http("http://booking.saltmines.us/info/webcal/258B66.ics")
    .get() (err, res, body) ->
      if res.statusCode is 200 and !err?
        ics = ical.parseICS(body)
        events = []
        for _, event of ics
          if event.type == 'VEVENT'
            today     = new Date
            starts    = new Date(event.start)
            ends   = new Date(event.end)
            if starts >= today
              if limit = null
                filter_end = new Date('2020-12-31 23:59:59')
              else
                #! Fix this—replace with tomorrow at midnight
                filter_end = new Date('2020-12-31 23:59:59')

              if ends <= filter_end
                events.push {
                  title: event.summary, starts: starts.getTime(), ends: ends.getTime()
                }
                msg.send "*#{event.summary}* from *#{event.start}* to *#{ends}*"

module.exports = (robot) ->
  robot.respond /schedule today/i, (msg) ->
    today = new Date
    showSchedule(msg, today)

  robot.respond /schedule$/i, (msg) ->
    showSchedule(msg)

