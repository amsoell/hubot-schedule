# hubot-schedule

Handles queries about upcoming scheduled events, looks them up in an iCalendar feed, and returns information to the user

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
user1>> hubot schedule today?
hubot>> Today's events: 
hubot>> *Intern Orientation* from *9am–12pm
hubot>> *Meeting with Client* rom *2pm–3pm
```
