function start()
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
    print(selectedCards)
    deck = group(selectedCards)

    deck = deck[1]
    deck.shuffle()

    deck.setPosition(getObjectFromGUID(180886).getPosition())

    self.UI.setAttribute("startButton", "active", false)

    
end