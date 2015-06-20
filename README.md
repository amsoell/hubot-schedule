# hubot-nowplaying

Queries music services to report what is playing at the moment (and recently)

See [`src/nowplaying.coffee`](src/nowplaying.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-nowplaying --save`

Then add **hubot-nowplaying** to your `external-scripts.json`:

```json
[
  "hubot-nowplaying"
]
```

## Sample Interaction

```
user1>> hubot what's playing?
hubot>> "Stairway to Heaven" by Led Zeppelin is playing on Radio Paradise right now
user1>> hubot what played before this?
hubot>> "Idiot Wind" by Bob Dylan
```
