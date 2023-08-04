deckZoneGUID = "180886"

game = require("start")
notes = require("notes")

startGame = coroutine.create(function ()
    -- pauses code
    coroutine.yield()
    -- resumes after start button is pressed

    -- pregame setup
    setScore()

    -- start game
    while (game.round <= 10) do
        startRound()
        endRound()
    end
end)

function onLoad()
    -- print game rules message

    -- starts game coroutine
    coroutine.resume(startGame)
end

function startRound()
    -- deal cards for each round
    game.deal()
    
end

function endRound()
    
end

function setScore()
    notes.update(game.players, game.round)
end