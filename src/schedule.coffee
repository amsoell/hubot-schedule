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
#   hubot schedule [today|tomorrow|monday] [calendarname] - Find out what events are scheduled
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

showSchedule = (msg, limit = null, cal_index = null) ->
  cals = {
    "south":"http://booking.saltmines.us/info/webcal/258B66.ics",
    "north":"http://booking.saltmines.us/info/webcal/26C631.ics"
  }
  if cal_index and cals.hasOwnProperty(cal_index)
    feed = cals[cal_index]
    cals = {}
    cals[cal_index] = feed
  days_of_week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  today = new Date
  if limit == null
    filter_start    = new Date
    filter_end      = new Date('2020-12-31 23:59:59')
  else
    filter_start    = new Date((limit.getYear()+1900)+'-'+(limit.getMonth()+1)+'-'+limit.getDate()+' 00:00:00')
    filter_end      = new Date((limit.getYear()+1900)+'-'+(limit.getMonth()+1)+'-'+limit.getDate()+' 23:59:59')

  if filter_start < today and today < filter_end
    filter_label = 'today'
  else
    filter_label = days_of_week[limit.getDay()]

  for calendar_name,calendar_url of cals
    do (calendar_name) ->
      msg.http(calendar_url)
        .get() (err, res, body) ->
          if res.statusCode is 200 and !err?
            ics = ical.parseICS(body)
            event_list = []
            for _, event of ics
              if event.type == 'VEVENT'
                starts    = new Date(event.start)
                ends   = new Date(event.end)

                if event.summary == undefined
                  event.summary = event.description
                if starts >= filter_start and ends <= filter_end
                  event_list.push "*#{event.summary}* from *#{getFormattedTime(starts)}* to *#{getFormattedTime(ends)}*"
            if event_list.length<=0
              msg.send "There are no events scheduled for " + filter_label + " at " + calendar_name
            else
              msg.send "Scheduled events for " + filter_label + " at " + calendar_name
              for event, k in event_list
                msg.send event

module.exports = (robot) ->
  robot.respond /schedule$/i, (msg) ->
    today = new Date
    showSchedule(msg, today)
  robot.respond /schedule (\w*)? ?(\w*)$/i, (msg) ->
    days_of_week = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    if msg.match[1] in days_of_week
      target_day = msg.match[1].toLowerCase()
      target = new Date
      while days_of_week[target.getDay()] != target_day
        target = new Date(target.getTime() + 86400000) # Add one day
      showSchedule(msg, target, msg.match[2])
    else if msg.match[2] in days_of_week
      target_day = msg.match[2].toLowerCase()
      target = new Date
      while days_of_week[target.getDay()] != target_day
        target = new Date(target.getTime() + 86400000) # Add one day
      showSchedule(msg, target, msg.match[1])
    else if msg.match[1]=="today"
      today = new Date
      showSchedule(msg, today, msg.match[2])
    else if msg.match[1]=="tomorrow"
      today = new Date
      tomorrow = new Date(today.getTime() + 86400000) # Add one day
      showSchedule(msg, tomorrow, msg.match[2])
    else if msg.match[2]=="today" or msg.match[1]
      today = new Date
      showSchedule(msg, today, msg.match[1])
    else if msg.match[2]=="tomorrow"
      today = new Date
      tomorrow = new Date(today.getTime() + 86400000) # Add one day
      showSchedule(msg, tomorrow, msg.match[1])