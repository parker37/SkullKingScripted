deckZoneGUID = "180886"

game = require("start")
notes = require("notes")

startGame = coroutine.create(function ()
    -- pauses code
    coroutine.yield()
    -- resumes after start button is pressed

    startRound()
end)

function onLoad()
    -- starts game coroutine
    coroutine.resume(startGame)
end

function startRound()
    game.deal()
    setScore()
end

function setScore()
    notes.update(game.players, game.round)
end