﻿local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Store the original position
local originalCFrame = humanoidRootPart.CFrame


-- Ensure this is placed inside a LocalScript

-- Get the player's PlayerGui
local player = game:GetService("Players").LocalPlayer
local playerGui = player.PlayerGui

-- Access the specific Label in the hierarchy
local label = playerGui:WaitForChild("UI"):WaitForChild("Gameplay"):WaitForChild("Character"):WaitForChild("Info"):WaitForChild("Label")

-- Change the Label text to "Makis Hub"
label.Text = "Makis Hub gg/PPnXACpfXT"

local player = game:GetService("Players").LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local gameplayUI = gui:WaitForChild("UI"):WaitForChild("Gameplay")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local chestRoll = gameplayUI:FindFirstChild("ChestRoll")
local selectAll = nil
local closeButton = nil


local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

_G.AutoFarm = false
_G.ItemESPEnabled = false -- Global toggle for ESP & Notifier
_G.SelectedEnemy = "Thug"
_G.PlayerESPEnabled = false -- Global toggle for Player ESP
_G.SelectedPlayer = "Everyone" -- Default to ESP everyone
_G.AutoChest = false
_G.NoItemFound = false
_G.InventoryLoopActive = false
_G.AutoSelling = false
_G.Teleportingye = false
_G.AutofarmSpeed = 0.5
_G.Itemfarmer = false
_G.SelectedEnemy = "nil"
_G.SelectedTp = "Tween"
_G.AutoChest = false
_G.SelectedAbilities = {} -- Default to all special abilities: Q, E, T, R
-- Initialize the exclusion list for item names
-- Initialize the exclusion list for item names
_G.ExcludedItemNames = {
    ["trowel"] = true,
    ["aja stone"] = true,
    ["altered steel ball"] = true,
    ["ban hammer"] = true,
    ["bat"] = false,
    ["arrow"] = false,
    ["bomb"] = false,
    ["busoshoku manual"] = true,
    ["chargin' targe"] = true,
    ["clackers"] = true,
    ["coal loot"] = true,
    ["dio's bone"] = true,
    ["dio's charm"] = true,
    ["evil fragments"] = true,
    ["flamethrower"] = true,
    ["frog"] = true,
    ["grenade launcher"] = true,
    ["kenbunshoku manual"] = true,
    ["knife"] = true,
    ["kuma's book"] = true,
    ["meat on a bone"] = true,
    ["metal loot"] = true,
    ["metal scraps"] = true,
    ["mount"] = true,
    ["mysterious hat"] = true,
    ["paintball gun"] = true,
    ["slingshot"] = true,
    ["sword"] = true,
    ["west blue juice"] = true,
    ["caesar's headband"] = true,
    ["dio's diary"] = true,
    ["saints eyes"] = true,
    ["mero devil fruit"] = true,
    ["golden hook"] = true,
    ["law's cap"] = true,
    ["manual of gryphon's techniques"] = true,
    ["mero mero no mi"] = true,
    ["ope ope no mi"] = true,
    ["gomu gomu no mi"] = true,
    ["light of hope"] = true,
    ["kuma's bible"] = true,
    ["joestar blood vial"] = true,
    ["true stone mask"] = true
}

local MoveInputService = ReplicatedStorage:WaitForChild("ReplicatedModules")
    :WaitForChild("KnitPackage"):WaitForChild("Knit")
    :WaitForChild("Services"):WaitForChild("MoveInputService")
    :WaitForChild("RF"):WaitForChild("FireInput")

local AttackKeys = { "Q", "E", "T", "R" }

local ChestNames = {
    "Common_Chest",  -- Updated with the correct name from your image
    "Rare_Chest",
    "Epic_Chest",
    "Legendary_Chest"
}

function AutoClick()
    while _G.AutoFarm do
        MoveInputService:InvokeServer("MouseButton1")
        wait(0.03)
        MoveInputService:InvokeServer("END-MouseButton1")
        wait(0.1)
    end
end

function AutoClickfinger()
    while _G.AutoFarmFinger do
        MoveInputService:InvokeServer("MouseButton1")
        wait(0.03)
        MoveInputService:InvokeServer("END-MouseButton1")
        wait(0.1)
    end
end

local enemies = {}
local uniqueNames = {} -- Table to track unique names

for _, obj in ipairs(game.Workspace.Living:GetChildren()) do
    if obj:IsA("Model") and not uniqueNames[obj.Name] then -- Ensure uniqueness
        uniqueNames[obj.Name] = true
        table.insert(enemies, obj.Name)
    end
end


function SpecialAttacks()
    while _G.AutoFarm do
        -- Check if there are no special abilities selected
        if not _G.SelectedAbilities or #_G.SelectedAbilities == 0 then
            -- If no abilities are selected, skip the attack logic
            wait(1)  -- Wait before checking again
            continue  -- Skip the rest of the loop
        end
        
        -- Only attack with abilities that are selected (not nil)
        for i, key in ipairs(_G.SelectedAbilities) do
            if key then
                Attack(key)  -- Attack with the selected key
                wait(0.5)  -- Reduced wait time for efficiency
            end
        end
        wait(3)  -- Reduced wait time for efficiency
    end
end

function SpecialAttacksFinger()
    while _G.AutoFarmFinger do
        -- Check if there are no special abilities selected
        if not _G.SelectedAbilities or #_G.SelectedAbilities == 0 then
            -- If no abilities are selected, skip the attack logic
            wait(1)  -- Wait before checking again
            continue  -- Skip the rest of the loop
        end
        
        -- Only attack with abilities that are selected (not nil)
        for i, key in ipairs(_G.SelectedAbilities) do
            if key then
                Attack(key)  -- Attack with the selected key
                wait(0.5)  -- Reduced wait time for efficiency
            end
        end
        wait(3)  -- Reduced wait time for efficiency
    end
end

function startSellingLoop()
    if _G.AutoSelling then
        spawn(function()  -- Startet den Loop in einem separaten Thread
            while _G.AutoSelling do
            local player = game.Players.LocalPlayer
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local itemsToSell = {}
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") then -- Ensure it's a tool
                        local itemId = item:GetAttribute("ItemId")
                        local uuid = item:GetAttribute("UUID")

                        if itemId and uuid then
                            table.insert(itemsToSell, {itemId, uuid, 1}) -- 1 is assumed quantity
                        end
                    end
                end
                if #itemsToSell > 0 then
                    local args = {
                        "BlackMarketBulkSellItems",
                        itemsToSell
                    }
                    local remotePath = game:GetService("ReplicatedStorage")
                        :WaitForChild("ReplicatedModules")
                        :WaitForChild("KnitPackage")
                        :WaitForChild("Knit")
                        :WaitForChild("Services")
                        :WaitForChild("ShopService")
                        :WaitForChild("RE")
                        :WaitForChild("Signal")
                    remotePath:FireServer(unpack(args))
                    print("Fired remote event with", #itemsToSell, "items.")
                else
                    print("No items found in the backpack.")
                end
            else
                warn("Backpack not found for player.")
            end
            
            wait(5) -- Adjust delay to prevent excessive server requests
        end
    end)
    end
end



_G.Itemfarmer = false -- Global toggle

local notifiedItems = {} -- Table to track notified items

function ItemNotifierAndESP()
    while _G.ItemESPEnabled do
        for _, itemSpawnFolder in pairs(game.Workspace.ItemSpawns:GetChildren()) do
            if itemSpawnFolder:IsA("Folder") then
                for _, spawnLocation in pairs(itemSpawnFolder:GetChildren()) do
                    if spawnLocation:IsA("BasePart") or spawnLocation:IsA("Model") then
                        for _, item in pairs(spawnLocation:GetChildren()) do
                            if item:IsA("MeshPart") or item:IsA("Model") or item:IsA("Part") then
                                if not item:FindFirstChild("ESPBox") then
                                    local highlight = Instance.new("Highlight")
                                    highlight.Parent = item
                                    highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow for visibility
                                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Red outline
                                    highlight.FillTransparency = 0.5
                                    highlight.OutlineTransparency = 0
                                    highlight.Name = "ESPBox"
                                end

                                if not item:FindFirstChild("NameTag") then
                                    local billboard = Instance.new("BillboardGui")
                                    billboard.Parent = item
                                    billboard.Size = UDim2.new(0, 200, 0, 50)
                                    billboard.Adornee = item
                                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                                    billboard.AlwaysOnTop = true
                                    billboard.Name = "NameTag"
                                    
                                    local textLabel = Instance.new("TextLabel")
                                    textLabel.Parent = billboard
                                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    textLabel.TextScaled = true
                                    textLabel.Font = Enum.Font.SourceSansBold
                                    textLabel.Name = "TextLabel"
                                end

                                local billboard = item:FindFirstChild("NameTag")
                                if billboard then
                                    local textLabel = billboard:FindFirstChild("TextLabel")
                                    if textLabel then
                                        local player = game.Players.LocalPlayer
                                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                            local distance = math.floor((player.Character.HumanoidRootPart.Position - item.Position).Magnitude)
                                            textLabel.Text = item.Name .. " (" .. distance .. " Studs)"
                                        end
                                    end
                                end
                                
                                if not notifiedItems[item] then
                                    notifiedItems[item] = true -- Mark item as notified
                                    warn("ðŸ”” Neues Item gefunden:", item.Name)
                                    game.StarterGui:SetCore("SendNotification", {
                                        Title = "Item Notifier",
                                        Text = "Gefunden: " .. item.Name,
                                        Duration = 3
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(5) -- Refresh rate to avoid overload
    end
    
    -- Cleanup ESP when disabled
    for _, itemSpawnFolder in pairs(game.Workspace.ItemSpawns:GetChildren()) do
        for _, spawnLocation in pairs(itemSpawnFolder:GetChildren()) do
            for _, item in pairs(spawnLocation:GetChildren()) do
                if item:IsA("MeshPart") or item:IsA("Model") or item:IsA("Part") then
                    local esp = item:FindFirstChild("ESPBox")
                    if esp then esp:Destroy() end
                    
                    local nameTag = item:FindFirstChild("NameTag")
                    if nameTag then nameTag:Destroy() end
                end
            end
        end
    end
    notifiedItems = {} -- Reset notified items when ESP is disabled
end

-- Start ESP if enabled
spawn(ItemNotifierAndESP)




function Attack(key)
    -- Ensure the key is valid and invoke the server to simulate the attack
    if key then
        print("Attacking with key:", key)  -- Debug log
        MoveInputService:InvokeServer(key)  -- Fire the key
        MoveInputService:InvokeServer("END-" .. key)  -- End the attack action
    else
        print("Invalid key:", key)  -- Debug log for invalid keys
    end
end




function MoveToTarget(target)
    local Character = player.Character or player.CharacterAdded:Wait()
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    
    -- Ensure the target has a HumanoidRootPart and is valid
    if not HRP or not target or not target:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- If the selected Tp method is Tween, create a tween
    if _G.SelectedTp == "Tween" then
        HRP.CFrame = CFrame.lookAt(HRP.Position, target.HumanoidRootPart.Position)
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
        local tweenGoal = { CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) }

        -- Safeguard for tween creation
        local tween = TweenService:Create(HRP, tweenInfo, tweenGoal)
        
        -- Check if the tween was created successfully
        if tween then
            tween:Play()
            tween.Completed:Wait()

            -- Ensure facing direction after the tween
            HRP.CFrame = CFrame.lookAt(HRP.Position, target.HumanoidRootPart.Position)
        end
    
    -- If the selected Tp method is Teleport, teleport the player
    elseif _G.SelectedTp == "Teleport" then
        -- Teleport to target's position with an offset to prevent clipping
        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end


local function Click(button)
    if button and button:IsA("GuiButton") and button.Visible then
        GuiService.SelectedObject = button
        wait(0.1)  -- Small delay before sending key event

        -- Simulate clicking the button
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

        wait(0.1)  -- Allow UI to process changes

        -- Forcefully clear selection to avoid auto-locking onto another UI button
        GuiService.SelectedObject = nil
        GuiService.AutoSelectGuiEnabled = false  -- Disable automatic UI selection
        wait(0.1)  
        GuiService.AutoSelectGuiEnabled = true  -- Re-enable after a short delay (optional)
    end
end


function OpenChest()
    while _G.AutoChest do
        -- Chest Collection Logic
        for _, v in ipairs(game.Workspace:GetDescendants()) do
            if v:IsA("BasePart") and table.find(ChestNames, v.Name) then
                local attachment = v:FindFirstChild("ProximityAttachment")
                if attachment then
                    local prox = attachment:FindFirstChild("Interaction")
                    if prox and prox:IsA("ProximityPrompt") then
                        print("âœ… ProximityPrompt triggered in:", v.Parent.Name)
                        prox.MaxActivationDistance = 5
                        fireproximityprompt(prox)
                    end
                end
            end
        end
        wait(1)  -- Shorter wait time for quicker detection of chests
    end
end




-- Start the farming process and attack
function StartFarming()
    -- Ensure AutoFarm is enabled
    while _G.AutoFarm do
        local Target = GetNearestEnemy()

        -- If a valid target is found
        if Target then
            -- Move to the target
            MoveToTarget(Target)

            -- Trigger AutoClick
            if AutoClick then
                coroutine.wrap(AutoClick)()
            else
                warn("AutoClick function is not defined.")
            end

            -- Trigger SpecialAttacks
            if SpecialAttacks then
                coroutine.wrap(SpecialAttacks)()
            else
                warn("SpecialAttacks function is not defined.")
            end

            -- Short wait to avoid an infinite tight loop and excessive resource usage
            wait(0.1)
        else
            -- If no target is found, wait a bit before checking again
            wait(0.5)
        end
    end
end

-- The teleportation function remains unchanged
local function TeleportToLeastPopulatedServer()
    if _G.Teleportingye and _G.NoItemFound then
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")

        local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Server, Next = nil, nil

        local function ListServers(cursor)
            local Raw = game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or ""))
            return HttpService:JSONDecode(Raw)
        end

        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[math.random(1, (#Servers.data / 3))]
            Next = Servers.nextPageCursor
        until Server

        if Server and Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
        end
    end
end


local function InventoryLoop()
    if _G.InventoryLoopActive and _G.NoItemFound then
    spawn(function()  -- Startet den Loop in einem separaten Thread
        while _G.InventoryLoopActive do
            -- Zugriff auf den lokalen Spieler und den Rucksack
            local player = game.Players.LocalPlayer
            local backpack = player.Backpack

            -- Zugriff auf den Remote-Event
            local inventoryService = game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedModules"):WaitForChild("KnitPackage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("ItemInventory")

            -- Alle Tools im Rucksack durchgehen
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    -- Nimm das Tool in die Hand
                    player.Character:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
                    
                    -- Warten, um sicherzustellen, dass das Tool in der Hand ist
                    wait(0.1)
                    
                    -- Remote-Event auslÃ¶sen
                    local args = {
                        [1] = {
                            ["AddItems"] = true  -- Beispiel-Argumente, die mitgeschickt werden
                        }
                    }
                    inventoryService:FireServer(unpack(args))
                    
                    -- Optional: Warte, bevor du das nÃ¤chste Tool in die Hand nimmst
                    wait(0.1)
                end
            end

            -- Warte eine kleine Zeit, bevor du erneut nach Items im Inventar schaust
            wait(1)
        end
    end)
end
end


function MoveToTargetFinger(target)
    local Character = player.Character or player.CharacterAdded:Wait()
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    
    -- Ensure the target has a HumanoidRootPart and is valid
    if not HRP or not target or not target:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- If the selected Tp method is Tween, create a tween
    if _G.SelectedTp == "Tween" then
        HRP.CFrame = CFrame.lookAt(HRP.Position, target.HumanoidRootPart.Position)
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
        local tweenGoal = { CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) }

        -- Safeguard for tween creation
        local tween = TweenService:Create(HRP, tweenInfo, tweenGoal)
        
        -- Check if the tween was created successfully
        if tween then
            tween:Play()
            tween.Completed:Wait()

            -- Ensure facing direction after the tween
            HRP.CFrame = CFrame.lookAt(HRP.Position, target.HumanoidRootPart.Position)
        end
    
    -- If the selected Tp method is Teleport, teleport the player
    elseif _G.SelectedTp == "Teleport" then
        -- Teleport to target's position with an offset to prevent clipping
        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end



function GetBearerQuest()
    print("Wip")
end



function Itemtp()
    while _G.Itemfarmer do
        local foundItem = false

        for _, itemSpawnFolder in pairs(game.Workspace.ItemSpawns:GetChildren()) do
            if itemSpawnFolder:IsA("Folder") then
                warn("âœ… ÃœberprÃ¼fe Ordner:", itemSpawnFolder.Name)

                for _, spawnLocation in pairs(itemSpawnFolder:GetChildren()) do
                    if spawnLocation:IsA("BasePart") then
                        warn("âœ… SpawnLocation gefunden:", spawnLocation.Name)

                        local hasItems = false -- Track if this spawnLocation has items

                        for _, child in pairs(spawnLocation:GetChildren()) do
                            if child:IsA("MeshPart") or child:IsA("Model") or child:IsA("Part") then
                                hasItems = true -- Es gibt ein Item, also teleportieren wir hin!

                                local player = game.Players.LocalPlayer
                                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    player.Character.HumanoidRootPart.CFrame = spawnLocation.CFrame
                                    warn("âœ… Spieler teleportiert zu:", spawnLocation.Name)
                                end

                                local attachment = child:FindFirstChild("ProximityAttachment")
                                if attachment then
                                    warn("âœ… ProximityAttachment gefunden in Model:", child.Name)

                                    local prox = attachment:FindFirstChild("Interaction")
                                    if prox then
                                        warn("âœ… ProximityPrompt gefunden in Model:", child.Name)

                                        prox.MaxActivationDistance = 10
                                        prox.HoldDuration = 0
                                        prox.ActionText = "makihub"
                                        prox.ObjectText = spawnLocation.Name
                                        prox.Enabled = true
                                        fireproximityprompt(prox)

                                        warn("âœ… ProximityPrompt aktiviert und Event-Handler gesetzt")
                                        foundItem = true
                                        break -- Stop checking this spawnLocation
                                    else
                                        warn("âŒ Kein ProximityPrompt gefunden in Model:", child.Name)
                                    end
                                else
                                    warn("âŒ Kein ProximityAttachment gefunden in Model:", child.Name)
                                end
                            end
                        end
                    end
                    if foundItem then break end -- Stop checking folders if item is found
                end
            end
            if foundItem then break end -- Stop checking everything if item is found
        end

        if not foundItem then
            _G.NoItemFound = true
            InventoryLoop()
        end

        if _G.NoItemFound and _G.Teleportingye then
            wait(5) -- â³ Verhindert zu schnelles Server-Hopping
            TeleportToLeastPopulatedServer()
        end

        wait(1) -- â³ Reduzierte Wartezeit fÃ¼r schnellere Suche
    end
end



function printExcludedItems()
    local excludedList = {}
    for itemName, _ in pairs(_G.ExcludedItemNames) do
        table.insert(excludedList, itemName)
    end
    print("ðŸ›‘ Excluded Items List: ", table.concat(excludedList, ", "))
end

-- Function to check if an item is in the exclusion list
function isExcluded(item)
    if item and _G.ExcludedItemNames[item.Name] then
        print("ðŸ›‘ Excluded from selling: " .. item.Name)
        return true
    end
    return false
end




-- Function to check if an item should be excluded from selling (based on its name)
function isExcluded(item)
    local itemName = item.Name:lower()  -- Convert to lowercase for case-insensitive comparison
    if _G.ExcludedItemNames[itemName] then
        print("ðŸš« SKIPPING ITEM:", itemName, "(EXCLUDED)")  -- Debug output to track excluded items
        return true  -- Return true if the item is excluded
    end
    return false  -- Otherwise, return false
end


-- Function to start the selling loop
function startSellingLoop()
    if _G.AutoSelling then
        spawn(function()  -- Start loop in a separate thread
            while _G.AutoSelling do
                local player = game.Players.LocalPlayer
                local backpack = player:FindFirstChild("Backpack")
                
                -- Check if backpack is found
                if backpack then
                    local itemsToSell = {}

                    print("ðŸŽ’ Checking Backpack Items...")  -- Debug print to check backpack

                    -- Iterate through all items in the backpack
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then  -- Ensure it's a tool
                            local itemName = item.Name
                            local itemId = item:GetAttribute("ItemId")
                            local uuid = item:GetAttribute("UUID")

                            print("ðŸ“Œ Found item:", itemName, "| ItemId:", itemId, "| UUID:", uuid)  -- Debug print for each item found

                            -- ðŸš« If item is excluded (value = true), SKIP it immediately
                            if isExcluded(item) then
                                -- Print exclusion for debugging
                                print("ðŸš« SKIPPING ITEM:", itemName, "(EXCLUDED)")  
                            else
                                -- âœ… Otherwise, add to selling list
                                if itemId and uuid then
                                    table.insert(itemsToSell, {itemId, uuid, 1}) -- 1 is assumed quantity
                                    print("âœ… Selling item: " .. itemName)  -- Debug print for selling items
                                end
                            end
                        end
                    end

                    -- If there are items to sell, sell them
                    if #itemsToSell > 0 then
                        local args = {
                            "BlackMarketBulkSellItems",
                            itemsToSell
                        }
                        local remotePath = game:GetService("ReplicatedStorage")
                            :WaitForChild("ReplicatedModules")
                            :WaitForChild("KnitPackage")
                            :WaitForChild("Knit")
                            :WaitForChild("Services")
                            :WaitForChild("ShopService")
                            :WaitForChild("RE")
                            :WaitForChild("Signal")
                        remotePath:FireServer(unpack(args))
                        print("ðŸ”¥ Sold", #itemsToSell, "items.")  -- Debug print to confirm sale
                    else
                        print("âš ï¸ No items to sell (all excluded or no sellable items).")  -- Debug print for empty itemsToSell
                    end
                else
                    warn("âŒ Backpack not found for player.")  -- Warn if backpack is not found
                end

                wait(5)  -- Prevent excessive server requests
            end
        end)
    end
end




function GetNearestEnemy()
    local player = game:GetService("Players").LocalPlayer
    if not player then return nil end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))
    if not hrp or not _G.SelectedEnemy then return nil end

    local closestEnemy = nil
    local closestDistance = math.huge

    -- Iterate through all NPCs in the Living folder
    for _, npc in ipairs(game.Workspace.Living:GetChildren()) do
        if npc:IsA("Model") and npc.Name == tostring(_G.SelectedEnemy) then
            local enemyTorso = npc:FindFirstChild("Torso") or npc:FindFirstChild("UpperTorso")
            if enemyTorso then
                local distance = (hrp.Position - enemyTorso.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = npc
                end
            end
        end
    end

    -- If no closest enemy is found, return nil
    if not closestEnemy then
        return nil
    end

    return closestEnemy
end
-- Start the farming process and attack


function GetNearestEnemyFinger()
    local player = game:GetService("Players").LocalPlayer
    if not player then return nil end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))


    local closestEnemy = nil
    local closestDistance = math.huge

    -- Iterate through all NPCs in the Living folder
    for _, npc in ipairs(game.Workspace.Living:GetChildren()) do
        if npc:IsA("Model") then
            local enemyTorso = npc:FindFirstChild("Torso") or npc:FindFirstChild("UpperTorso")
            if enemyTorso then
                local distance = (hrp.Position - enemyTorso.Position).Magnitude
                if npc.Name == "The Bearer" then
                    return npc -- Prioritize "The Bearer"
                elseif npc.Name == "Jujutsu Sorcerer" or npc.Name == "Mantis Curse" or npc.Name == "Roppongi Curse" or npc.Name == "Flyhead" then
                    if distance < closestDistance then
                        closestDistance = distance
                        closestEnemy = npc
                    end
                end
            end
        end
    end

    -- If no closest enemy is found, return nil
    if not closestEnemy then
        return nil
    end

    return closestEnemy
end

function StartFarmingFinger() 
    local player = game:GetService("Players").LocalPlayer
    if not player then return nil end

    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")

    if _G.AutoFarmFinger == true then 
        hrp.CFrame =  CFrame.new(1939, 934, -1636)
        while _G.AutoFarmFinger do
            local Target = GetNearestEnemyFinger()
            if Target then
                -- Move to the target
                MoveToTargetFinger(Target)
                GetBearerQuest()
                -- Trigger AutoClick
                if AutoClickfinger then
                    coroutine.wrap(AutoClickfinger)()
                else
                    warn("AutoClick function is not defined.")
                end

                -- Trigger SpecialAttacks
                if SpecialAttacksFinger then
                    coroutine.wrap(SpecialAttacksFinger)()
                else
                    warn("SpecialAttacks function is not defined.")
                end

                -- Short wait to avoid an infinite tight loop and excessive resource usage
                wait(0.1)
            else
                -- If no target is found, wait a bit before checking again
                wait(0.5)
            end
        end
    end
end


function killall()
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if _G.InstaKill == true then
            pcall(function()
                for _, k in ipairs(workspace.Living:GetChildren()) do
                    if k:IsA("Model") and k:FindFirstChild("Head") and k.Head:IsA("Part") and k.Head.Name == "Head" and k.Head ~= game.Players.LocalPlayer.Character.Head then
                        -- Check if the NPC has a humanoid and the humanoid's health is not at max
                        local humanoid = k:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health ~= humanoid.MaxHealth then
                            -- Kill the NPC
                            humanoid.Health = 0
                        end
                    end
                end
            end)
        else
            -- Disconnect when killall is set to false
            connection:Disconnect()
        end
    end)
end


local Window = Library:CreateWindow({
    Title = 'Makis AUT Script',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ESPTab = Window:AddTab('ESP'),
    ['UI Settings'] = Window:AddTab('UI Settings')
    
}

local FarmGroup = Tabs.Main:AddLeftGroupbox('AutoFarm Settings')
local ESPGroup = Tabs.ESPTab:AddLeftGroupbox('ESP Settings')
local MiscTab = Tabs.Main:AddRightGroupbox('Misc Tab')
local FingerFarm = Tabs.Main:AddRightGroupbox('Finger Farm')
_G.AutoFarm = false
_G.SelectedEnemy = "Thug"
_G.AutoChest = false

FarmGroup:AddToggle('AutoFarmToggle', {
    Text = 'AutoFarm Toggle',
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        StartFarming()

    end
})

FarmGroup:AddToggle('Itemfarmer', {
    Text = 'Itemfarm Toggle',
    Default = false,
    Callback = function(Value)
        _G.Itemfarmer = Value  -- Toggle AutoChest feature
        
    end
})

Toggles.Itemfarmer:OnChanged(function()
    Itemtp()
end)

FarmGroup:AddDropdown('EnemiesDp', {
    Values = enemies, -- List of enemy names (strings)
    Default = 1, 
    Multi = false, 
    Text = 'Select AutoFarm Target',
    Tooltip = 'Default is 1',

    Callback = function(Value)
        _G.SelectedEnemy = tostring(Value) -- Ensure it's stored as a string
    end
})



MiscTab:AddButton('ReloadEnemie', function()

    for _, obj in ipairs(game.Workspace.Living:GetChildren()) do
        if obj:IsA("Model") and not uniqueNames[obj.Name] then -- Ensure uniqueness
            uniqueNames[obj.Name] = true
            table.insert(enemies, obj.Name)
            Options.EnemiesDp:SetValue(enemies)
        end
    end

end)

FarmGroup:AddToggle('AutoChestToggle', {
    Text = 'AutoChest Toggle',
    Default = false,
    Callback = function(Value)
        _G.AutoChest = Value  -- Toggle AutoChest feature

    end
})

Toggles.AutoChestToggle:OnChanged(function(Value)
    if chestRoll then
            chestRoll:Destroy()  -- Destroy chestRoll if it exists
            OpenChest()
    else
            _G.AutoChest = Value  -- Toggle AutoChest feature
            -- Call the appropriate function for AutoChest (replace 123 with the correct function)
            OpenChest() -- You need to define this function
    end
end)


FarmGroup:AddDropdown('SpeedAutofarm', {
    Values = {0.01, 0.1, 0.5, 1, 2, 3, 4, 5 },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Select AutoFarm Speed',
    Tooltip = 'Default is 1', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        
        _G.AutofarmSpeed = Value
        
    end
})

FarmGroup:AddDropdown('GoMethod', {
    Values = {"Tween", "Teleport"},
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Select Tp Method',
    Tooltip = 'Default is Tween', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        
        _G.SelectedTp = Value
        
    end
})


FarmGroup:AddDropdown('Ability1', {
    Values = {"None", "Q", "E", "T", "R"}, -- List of attack keys with "None"
    Default = "None",  -- Default is None for Ability 1
    Multi = false,  -- Only one key for Ability 1
    Text = 'Select Key for Ability 1',
    Tooltip = 'Choose the key for Ability 1, or None to disable',
    
    Callback = function(Value)
        if Value == "None" then
            _G.SelectedAbilities[1] = nil  -- Remove Ability 1
        else
            _G.SelectedAbilities[1] = Value  -- Map Ability 1 to selected key
        end
    end
})

FarmGroup:AddDropdown('Ability2', {
    Values = {"None", "Q", "E", "T", "R"}, -- List of attack keys with "None"
    Default = "None",  -- Default is None for Ability 2
    Multi = false,  -- Only one key for Ability 2
    Text = 'Select Key for Ability 2',
    Tooltip = 'Choose the key for Ability 2, or None to disable',
    
    Callback = function(Value)
        if Value == "None" then
            _G.SelectedAbilities[2] = nil  -- Remove Ability 2
        else
            _G.SelectedAbilities[2] = Value  -- Map Ability 2 to selected key
        end
    end
})

FarmGroup:AddDropdown('Ability3', {
    Values = {"None", "Q", "E", "T", "R"}, -- List of attack keys with "None"
    Default = "None",  -- Default is None for Ability 3
    Multi = false,  -- Only one key for Ability 3
    Text = 'Select Key for Ability 3',
    Tooltip = 'Choose the key for Ability 3, or None to disable',
    
    Callback = function(Value)
        if Value == "None" then
            _G.SelectedAbilities[3] = nil  -- Remove Ability 3
        else
            _G.SelectedAbilities[3] = Value  -- Map Ability 3 to selected key
        end
    end
})

FarmGroup:AddDropdown('Ability4', {
    Values = {"None", "Q", "E", "T", "R"}, -- List of attack keys with "None"
    Default = "None",  -- Default is None for Ability 4
    Multi = false,  -- Only one key for Ability 4
    Text = 'Select Key for Ability 4',
    Tooltip = 'Choose the key for Ability 4, or None to disable',
    
    Callback = function(Value)
        if Value == "None" then
            _G.SelectedAbilities[4] = nil  -- Remove Ability 4
        else
            _G.SelectedAbilities[4] = Value  -- Map Ability 4 to selected key
        end
    end
})

FingerFarm:AddToggle('AutoFarmCurses', {
    Text = 'Auto Farm Curses',
    Default = false,
    Callback = function(Value)
        _G.AutoFarmFinger = Value
    end
})

Toggles.AutoFarmCurses:OnChanged(function()
    StartFarmingFinger()
end)

MiscTab:AddButton('Standless', function()

        local args = {
            [1] = "Reset Stand"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("ReplicatedModules"):WaitForChild("KnitPackage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("DialogueService"):WaitForChild("RF"):WaitForChild("CheckDialogue"):InvokeServer(unpack(args))

end)

MiscTab:AddButton('Sell Items', function()
        local player = game.Players.LocalPlayer
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            local itemsToSell = {}
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then -- Ensure it's a tool
                    local itemId = item:GetAttribute("ItemId")
                    local uuid = item:GetAttribute("UUID")

                    if itemId and uuid then
                        table.insert(itemsToSell, {itemId, uuid, 1}) -- 1 is assumed quantity
                    end
                end
            end
            if #itemsToSell > 0 then
                local args = {
                    "BlackMarketBulkSellItems",
                    itemsToSell
                }
                local remotePath = game:GetService("ReplicatedStorage")
                    :WaitForChild("ReplicatedModules")
                    :WaitForChild("KnitPackage")
                    :WaitForChild("Knit")
                    :WaitForChild("Services")
                    :WaitForChild("ShopService")
                    :WaitForChild("RE")
                    :WaitForChild("Signal")
                remotePath:FireServer(unpack(args))
                print("Fired remote event with", #itemsToSell, "items.")
            else
                print("No items found in the backpack.")
            end
        else
            warn("Backpack not found for player.")
        end
end)





MiscTab:AddButton('Rejoin Server', function()
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")

    local function rejoinGame()
        local player = Players.LocalPlayer
        local currentPlaceId = game.PlaceId  -- Get the current place ID

        -- Teleport player to the same place, effectively rejoining
        TeleportService:Teleport(currentPlaceId, player)
    end

    -- Call this function when you want to rejoin
    rejoinGame()
end)


-- GUI Toggle to control server hopping while item farming
MiscTab:AddToggle('ServerHopwhileItemFarm', {
    Text = 'Serverhopitemfarm',
    Default = false,
    Callback = function(Value)
        _G.Teleportingye = Value  -- Update the global variable when the toggle changes
        warn("âœ… Server Hopping Toggle gesetzt auf: " .. tostring(Value))  -- Debugging line to confirm the toggle state
    end
})


Toggles.ServerHopwhileItemFarm:OnChanged(function()
    TeleportToLeastPopulatedServer()
end)


MiscTab:AddToggle('ItemSaver', {
    Text = 'Itemsaving Toggle',
    Default = false,
    Callback = function(Value)
        _G.InventoryLoopActive = Value  -- Update the global variable when the toggle changes
    end
})


-- Example of how to toggle auto-selling (you can set this in your UI)
MiscTab:AddToggle('AutoSellItems', {
    Text = 'Auto Sell Items',
    Default = false,
    Callback = function(Value)
        _G.AutoSelling = Value  -- Update the global variable
        if _G.AutoSelling then
            warn("âœ… Auto Sell Items: ON")
            startSellingLoop()  -- Start loop when enabled
        else
            warn("âŒ Auto Sell Items: OFF")
        end
    end
})

-- Dropdown for selecting items to exclude from selling
local dropdown = MiscTab:AddDropdown('ExcludedItemSpawns', {
    Values = {
        "Trowel", 
        "Aja Stone", 
        "Altered Steel Ball", 
        "Ban Hammer", 
        "Bat", 
        "Arrow", 
        "Bomb", 
        "Busoshoku Manual", 
        "Chargin' Targe", 
        "Clackers", 
        "Coal Loot", 
        "DIO's Bone", 
        "Dio's Charm", 
        "Evil Fragments",
        "Flamethrower",
        "Frog",
        "Grenade Launcher",
        "Kenbunshoku Manual",
        "Knife",
        "Kuma's Book",
        "Meat On A Bone",
        "Metal Loot",
        "Metal Scraps",
        "Mount",
        "Mysterious Hat",
        "Paintball Gun",
        "Slingshot",
        "Sword",
        "West Blue Juice",
        "Caesar's Headband",
        "DIO's Diary",
        "Saints Eyes",
        "Mero Devil Fruit",
        "Golden Hook",
        "Law's Cap",
        "Manual of Gryphon's Techniques",
        "Mero Mero No Mi",
        "Ope Ope No Mi",
        "Gomu Gomu No Mi",
        "Light Of Hope",
        "Kuma's Bible",
        "Joestar Blood Vial",
        "True Stone Mask",
    },  -- List of items to exclude from selling
    Default = {},  -- Default is empty (no exclusions)
    Multi = true,  -- Allow multiple selections
    Text = 'Select Items to Exclude from Selling',  -- Text for the dropdown
    Tooltip = 'Choose the items whose names should not be sold',  -- Tooltip for extra info
})

-- Function to update _G.ExcludedItemNames based on dropdown values
local function UpdateExcludedItems()
    for _, itemName in ipairs(dropdown.Values) do
        -- If the item is selected, set it to true; if unselected, set it to false
        if dropdown.Value[itemName] then
            _G.ExcludedItemNames[itemName:lower()] = true
        else
            _G.ExcludedItemNames[itemName:lower()] = false
        end
    end
end

-- Listen for dropdown changes
dropdown:OnChanged(function()
    -- Update _G.ExcludedItemNames when selections change
    UpdateExcludedItems()

    -- Debug print to check the updated exclusions
    print("[cb] _G.ExcludedItemNames updated:", _G.ExcludedItemNames)
end)

-- Initialize Exclusions based on the default state (before any interaction)
UpdateExcludedItems()

ESPGroup:AddToggle('ItemEpandNotifier', {
    Text = 'ItemfarmESP Toggle',
    Default = false,
    Callback = function(Value)
        _G.ItemESPEnabled = Value  -- Toggle AutoChest feature

    end
})

Toggles.ItemEpandNotifier:OnChanged(function()
    ItemNotifierAndESP()
end)

MiscTab:AddToggle('Instakill', {
    Text = 'Instakill TimeStop',
    Default = false,
    Callback = function(Value)
        _G.InstaKill = Value  -- Toggle AutoChest feature

    end
})

Toggles.Instakill:OnChanged(function()
    killall()
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
