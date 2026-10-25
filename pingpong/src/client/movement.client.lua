

local UserInputService = game:GetService("UserInputService")

local teclas = {}



local ReplicatedStorage = game["ReplicatedStorage"]
local event_movement = ReplicatedStorage:WaitForChild("event_movement")

local function atualizar_movimento()
    local cima = teclas[Enum.KeyCode.Up] or teclas[Enum.KeyCode.W]
    local baixo = teclas[Enum.KeyCode.Down] or teclas[Enum.KeyCode.S]

    local eixoY = (cima and 1 or 0) - (baixo and 1 or 0)

    event_movement:FireServer(eixoY)
   -- print("DEBUG atualizar_movimento() client -> \n Status -> movendo")
end

UserInputService.InputBegan:Connect(function(input, gameprocessed)
    if gameprocessed then return end

    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end
    teclas[input.KeyCode] = true

    print("DEBUG input_began() client -> \n Status -> apertando. Key -> " .. tostring(input.KeyCode))
    atualizar_movimento()

end)

UserInputService.InputEnded:Connect(function(input, gameprocessed)
    if gameprocessed then return end

    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    teclas[input.KeyCode] = 
    print("DEBUG input_ended() client -> \n Status -> fora. Key -> " .. tostring(input.KeyCode))

    atualizar_movimento()
end)

