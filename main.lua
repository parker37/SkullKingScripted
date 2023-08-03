deckZoneGUID = "180886"

game = require("start")
notes = require("notes")

startGame = coroutine.create(function ()
    print("In game loop. Before coroutine yield")
    coroutine.yield()
    print("In game loop.")

    startRound()
    --deck.getDeck()
    --print(mainDeck.deck)
end)

function onLoad()
    coroutine.resume(startGame)
end

function startRound()
    game.deal()
    setScore()
end

function setScore()
    notes.update(game.players, game.round)
end