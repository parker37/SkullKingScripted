function onload()
    printToAll('Loaded')

    --spawnObject('Checker_black', )--

    pos = getObjectFromGUID('c08b61').getPosition()
    pos[3] = pos[3] + 5

    piece = spawnObject({
        type = 'Checker_black',
        position = pos
    })

    piece.createButton({
        click_function = 'reset',
        label = 'Reset',
        position = {0,1,0},
        scale = {10,10,10}
    })
    piece.locked = true

end

function reset()
    print('RESET!')
end