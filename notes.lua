local notes = {}

function notes.update(players, roundNum)
    message = ""
    round = "Round " .. tostring(roundNum) .. "\n-----------\n\n"

    for name, data in pairs(players) do
        message = message .. name .. ": " .. tostring(data.score) .. "\n"
    end

    setNotes(round .. message)

end

return notes