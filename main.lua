deckZoneGUID = "180886"
tokenZoneGUID = "bea601"
centerZoneGUID = "fe0fde"
discardZoneGUID = "97cc6c"
trickZones = {"cb2627", "370946", "c05194", "14c14e", "0c7027", "2824e8", "db3768", "abc9b2"}

game = require("start")
notes = require("notes")
scores = require("scores")

startGame = coroutine.create(function ()
    -- pauses code
    coroutine.yield()
    -- resumes after start button is pressed

    -- pregame setup
    setScore()

    -- start game
        startRound()
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
    -- hides end round button and shows lock in button
    self.UI.setAttribute("scoreButton", "active", false)
    self.UI.setAttribute("lockInButton", "active", true)
    self.UI.setAttribute("claimTrickButton", "active", false)
    self.UI.setAttribute("trashTrickButton", "active", false)

    -- increases the game round
    game.round = game.round + 1

    -- sets score
    setScore()

    -- searches all snap points
    snapPoints = Global.getSnapPoints()
    for _, sP in ipairs(snapPoints) do
        -- finds the discard pile snap point
        if (sP.tags[1] == "card" and sP.tags[2] == "Discard") then
            -- adds that snap point to a seperate variable to use for position and rotation
            snapPoint = sP
        end
    end

    -- check trick win piles for tricks and move them to discard
    for _, x in ipairs(trickZones) do
        tricks = getObjectFromGUID(x).getObjects()
        if (#tricks > 0) then
            -- set position and rotation to discard snap point
            -- 0 to make sure it is flipped up
            tricks[1].setPosition({snapPoint.position[1],snapPoint.position[2],snapPoint.position[3]})
            tricks[1].setRotation({snapPoint.rotation[1],snapPoint.rotation[2],0})
        end
    end

    

    -- play deck
    deckPile = getObjectFromGUID(deckZoneGUID).getObjects()
    
    -- searches for all the tokens and flips them face down for next round
    tokens = getObjectsWithTag("token")
    for _, t in ipairs(tokens) do
        t.flip()
    end

    -- flips the deck, ready to move discard
    deckPile[1].flip()

    -- pauses to give time for the deck to flip and tricks to move to discard
    Wait.time(
        function ()
        -- discard pile
        discardPile = getObjectFromGUID(discardZoneGUID).getObjects()

        -- moves discard over to deck, but puts it above it to give extra time to make sure the cards go on the bottom
        discardPile[1].setPosition({deckPile[1].getPosition().x, deckPile[1].getPosition().y+4, deckPile[1].getPosition().z})
        

        -- wait time before getting new deck
        Wait.time(
            function ()
                newDeck = getObjectFromGUID(deckZoneGUID).getObjects()
                newDeck[1].flip()
                game.deck = newDeck[1]
                
                -- wait after flip to do the startRound function so it doesn't deal the bottom cards
                Wait.time(
                    function ()
                        startRound()
                    end,
                    0.5)
            end,
            0.7)
        end,
        0.5)
end

function setScore()
    notes.update(game.players, game.round)
end










-- function that takes the player who clicked the button and gives them the cards for the trick
function claimTrick(player)

    -- gets card zone and creates an empty table for the cards
    objects = getObjectFromGUID(centerZoneGUID).getObjects()
    p = getSeatedPlayers()
    cards = {}
    hands = Hands.getHands()
    v=false

    -- searches all objects in the zone and gets the ones that are cards
    for _, obj in ipairs(objects) do
        if (obj.hasTag("Card")) then
            -- puts the cards into a table
            table.insert(cards, obj)
        end
    end

    -- checks that everyone has played a card incase of accidental button press
    if (#cards < #p) then
        broadcastToAll("Everyone needs to play a card before ending the trick.", white)
        return
    end

    -- groups the cards
    g = group(cards)

    snapPoints = Global.getSnapPoints()
    -- iterates through all the player won trick zones
    for _, snapPoint in ipairs(snapPoints) do
        -- for each snap point, it checks if the color tag matches the color player for who pressed the button
        if ((snapPoint.tags[2] == player.color or snapPoint.tags[1] == player.color) 
        and (snapPoint.tags[2] == "card" or snapPoint.tags[1] == "card")) then

            -- if it does, move the card deck to that zone
            g[1].setPosition({snapPoint.position[1],snapPoint.position[2],snapPoint.position[3]})
            g[1].setRotation({snapPoint.rotation[1],snapPoint.rotation[2],0})
        end
    end

    -- checks that all players are out of cards, if they aren't, end function
    for _, hand in ipairs(hands) do
        x = hand.getObjects()

        if (#x > 0) then
            return
        end
    end

    -- makes the end round button visible
    self.UI.setAttribute("scoreButton", "active", true)
end



-- function that discards trick when button is pressed
function trashTrick()

    -- gets card zones and creates an empty table for the cards
    objects = getObjectFromGUID(centerZoneGUID).getObjects()
    trash = getObjectFromGUID(discardZoneGUID)
    p = getSeatedPlayers()
    hands = Hands.getHands()
    cards = {}

    -- searches all snap points
    snapPoints = Global.getSnapPoints()
    for _, sP in ipairs(snapPoints) do
        -- finds the discard pile snap point
        if (sP.tags[1] == "card" and sP.tags[2] == "Discard") then
            -- adds that snap point to a seperate variable to use for position and rotation
            snapPoint = sP
        end
    end

    -- searches all objects in the zone and gets the ones that are cards
    for _, obj in ipairs(objects) do
        if (obj.hasTag("Card")) then
            -- puts the cards into a table
            table.insert(cards, obj)
        end
    end

    -- checks that everyone has played a card incase of accidental button press
    if (#cards < #p) then
        broadcastToAll("Everyone needs to play a card before ending the trick.", white)
        return
    end

    -- groups the cards and moves them to discard stack
    g = group(cards)
    g[1].setPosition({snapPoint.position[1],snapPoint.position[2],snapPoint.position[3]})
    g[1].setRotation({snapPoint.rotation[1],snapPoint.rotation[2],0})

    -- checks that all players are out of cards, if they aren't, end function
    for _, hand in ipairs(hands) do
        x = hand.getObjects()

        if (#x > 0) then
            return
        end
    end
    
    -- makes the end round button visible
    self.UI.setAttribute("scoreButton", "active", true)
end

function lockIn(player)
    -- gets all tokens
    tokenTable = getObjectsWithTag("token")

    -- empty table to store locked tokens
    lockedTokens = {}

    -- search through the tokens
    for _, token in ipairs(tokenTable) do
        -- if the token color matches the player color then lock the token
        if (token.hasTag(player.color)) then
            token.setLock(true)
        end

        -- if the token is not locked, then end the function
        if (token.getLock() == false) then
            return
        end

        -- add any tokens that make it past the last if statement to the lockedTokens table
        table.insert(lockedTokens, token)
    end

    -- unlocks all tokens and flips them
    for _, x in ipairs(lockedTokens) do
        x.setLock(false)
        x.flip()
    end
    
    -- says "YO HO HO" to the game and hides the lock in button
    broadcastToAll("YO HO HO")
    self.UI.setAttribute("lockInButton", "active", false)
    self.UI.setAttribute("claimTrickButton", "active", true)
    self.UI.setAttribute("trashTrickButton", "active", true)
end