local start = {}

start.deck = {}
start.players = {}
start.round = 0

function start.deal() 
    start.deck.deal(start.round)
end

function setup()
    cardZone = getObjectFromGUID("fe0fde").getObjects()
        -- Zone.getObjects() returns {Object, ...}
    selectedCards = {}

    for _,cards in ipairs(cardZone) do
        
        if(cards.is_face_down) then
            table.insert(selectedCards, cards)
        else
            cards.destruct()
        end
    end
    
    deck = group(selectedCards)

    start.deck = deck[1]
    start.deck.shuffle()
    start.deck.setPosition(getObjectFromGUID(180886).getPosition())

    self.UI.setAttribute("startButton", "active", false)
    getObjectFromGUID("fe0fde").destruct()
    
    for _,player in ipairs(Player.getPlayers()) do
        
        start.players[player.steam_name] = {
            score = 0, 
            color = player.color
        }
    end

    start.round = 1

    coroutine.resume(startGame)
end


return start