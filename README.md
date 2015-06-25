# hubot-schedule

Handles queries about upcoming scheduled events, looks them up in an iCalendar feed, and returns information to the user
Also automatically sends upcoming event reminders to the #general room

See [`src/schedule.coffee`](src/schedule.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-schedule --save`

Then add **hubot-schedule** to your `external-scripts.json`:

```json
[
  "hubot-schedule"
]
```

## Sample Interaction

```
user1>> hubot schedule today
hubot>> *Intern Orientation* from *9am* to *12pm*
hubot>> *Meeting with Client* from *2pm* to *3pm*
user1>> hubot schedule tomorrow
hubot>> *Member Lunch* from *12pm* to *1pm*
user1>> hubot schedule Wednesday
hubot>> There are no events scheduled for Wednesday
```
## Todo

- [ ] Mute upcoming event reminders on weekends and non-business hours