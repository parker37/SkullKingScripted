-- creates main object of game
local start = {}

-- declaring variables for use during game
start.deck = {}
start.players = {}
start.round = 0

-- deals cards to players based on the round number
function start.deal() 
    start.deck.deal(start.round)
end

function setup()
    -- gets all cards from starting zone
    cardZone = getObjectFromGUID("fe0fde").getObjects()
        
    -- creates table for player selected cards
    selectedCards = {}

    -- loops through all objects in card zone
    for _,cards in ipairs(cardZone) do

        -- adds face down cards to selected cards table
        if (cards.is_face_down) then
            table.insert(selectedCards, cards)
        else
            -- deletes cards that aren't used in the game
            cards.destruct()
        end
    end
    
    -- groups all selected cards to one stack
    deck = group(selectedCards)

    -- gets card deck, shuffles it, and moves it to the game deck zone
    start.deck = deck[1]
    start.deck.shuffle()
    start.deck.setPosition(getObjectFromGUID(180886).getPosition())

    -- deletes start game ui button and starting zone
    self.UI.setAttribute("startButton", "active", false)
    getObjectFromGUID("fe0fde").destruct()
    
    -- gets players currently in game with color, steam_name, and set a score
    for _,player in ipairs(Player.getPlayers()) do
        if (player.color ~= "Grey" and player.color ~= "Black") then
            start.players[player.steam_name] = {
                score = 0, 
                color = player.color
            }
        end
    end

    -- sets round to 1
    start.round = 1

    -- continues running startGame code
    coroutine.resume(startGame)
end

-- return start table of data to other files
return start