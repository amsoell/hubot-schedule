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
#   hubot schedule - Find out what events are scheduled for today
#   hubot schedule (tomorrow|monday|etc) - Find out events that are scheduled in the future
ical = require 'ical'

getFormattedTime = (d) ->
  if d.getHours()==12
    formatted = '12'
  else
    formatted = d.getHours()%12
  formatted += ':'

  if d.getMinutes()<10
    formatted += '0'
  formatted += d.getMinutes()

  if d.getHours()>=12
    formatted += 'pm'
  else
    formatted += 'am'

showSchedule = (msg, limit = null) ->
  days_of_week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  today = new Date
  if limit == null
    filter_start    = new Date
    filter_end      = new Date('2020-12-31 23:59:59')
  else
    #! Fix this—replace with tomorrow at midnight
    filter_start    = new Date((limit.getYear()+1900)+'-'+(limit.getMonth()+1)+'-'+limit.getDate()+' 00:00:00')
    filter_end      = new Date((limit.getYear()+1900)+'-'+(limit.getMonth()+1)+'-'+limit.getDate()+' 23:59:59')

  if filter_start < today and today < filter_end
    filter_label = 'today'
  else
    filter_label = days_of_week[limit.getDay()]

  msg.http("http://booking.saltmines.us/info/webcal/258B66.ics")
    .get() (err, res, body) ->
      if res.statusCode is 200 and !err?
        ics = ical.parseICS(body)
        event_count = 0
        for _, event of ics
          if event.type == 'VEVENT'
            starts    = new Date(event.start)
            starts_formatted = getFormattedTime(starts)

            ends   = new Date(event.end)
            ends_formatted = getFormattedTime(ends)

            if event.summary == undefined
              event.summary = event.description
            if starts >= filter_start
              if ends <= filter_end
                event_count++
                msg.send "*#{event.summary}* from *#{starts_formatted}* to *#{ends_formatted}*"
        if event_count<=0
          msg.send "There are no events scheduled for " + filter_label

module.exports = (robot) ->
  robot.respond /schedule$/i, (msg) ->
    today = new Date
    showSchedule(msg, today)
  robot.respond /schedule tomorrow/i, (msg) ->
    today = new Date
    tomorrow = new Date(today.getTime() + 86400000) # Add one day
    showSchedule(msg, tomorrow)
  robot.respond /schedule (monday|tuesday|wednesday|thursday|friday|saturday|sunday)/i, (msg) ->
    days_of_week = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    target_day = msg.match[1].toLowerCase()

    target = new Date

    while days_of_week[target.getDay()] != target_day
      target = new Date(target.getTime() + 86400000) # Add one day

    showSchedule(msg, target)

