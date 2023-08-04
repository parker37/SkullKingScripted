deckZoneGUID = "180886"
trickZones = {"370946", "cbc834", "750e8e", "160e5d", "0e6991", "d5576b", "8a40f0", "d981c9"}

game = require("start")
notes = require("notes")
scores = require("scores")

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







--[[ function test()
    print("in function")
    hands = Hands.getHands()
    for _, hand in ipairs(hands) do
        x = hand.getObjects()
        if #x > 0 then
            for _, tag in ipairs(x[1].getTags()) do
                print(tag)
            end
        end
    end
end ]]--

function claimTrick(player)
    objects = getObjectFromGUID("fe0fde").getObjects()
    cards = {}

    for _, obj in ipairs(objects) do
        if obj.hasTag("Card") then
            table.insert(cards, obj)
        end
    end

    g = group(cards)
    for _, zoneGUID in ipairs(trickZones) do
        zone = getObjectFromGUID(zoneGUID)
        if (zone.hasTag(player.color)) then
            g[1].setPosition(zone.getPosition())
        end
    end
end