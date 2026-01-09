local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- UI ANA YAPI (EndardHub)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ActionButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local ComboContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "EndardHub_UI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "EndardHub"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

CloseButton.Parent = MainFrame
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 1
CloseButton.TextSize = 22

ComboContainer.Name = "ComboContainer"
ComboContainer.Parent = MainFrame
ComboContainer.BackgroundTransparency = 1
ComboContainer.Position = UDim2.new(0.05, 0, 0.2, 0)
ComboContainer.Size = UDim2.new(0.9, 0, 0.45, 0)
ComboContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ComboContainer.ScrollBarThickness = 2

UIListLayout.Parent = ComboContainer
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ActionButton.Parent = MainFrame
ActionButton.Position = UDim2.new(0.1, 0, 0.75, 0)
ActionButton.Size = UDim2.new(0.8, 0, 0.2, 0)
ActionButton.Text = "ÇALIŞTIR (Işınlan + 40x)"
ActionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActionButton.Font = Enum.Font.GothamBold
ActionButton.TextScaled = true
Instance.new("UICorner", ActionButton)

-----------------------------------------------------------
-- NAME UPDATER (.gg/EndardHub) - SÜREKLİ KONTROL
-----------------------------------------------------------
local nameUpdaterActive = true
task.spawn(function()
    while nameUpdaterActive do
        pcall(function()
            local hBars = LocalPlayer.PlayerGui:FindFirstChild("healthbars")
            if hBars then
                for _, child in pairs(hBars:GetDescendants()) do
                    if child.Name == "NameT" and child:IsA("TextLabel") then
                        if child.Parent.Name == LocalPlayer.Name or child.Parent:FindFirstChild(LocalPlayer.Name) then
                            if child.Text ~= ".gg/EndardHub" then
                                child.Text = ".gg/EndardHub"
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-----------------------------------------------------------
-- COMBOBOX İTEMLERİ
-----------------------------------------------------------
local SelectedItems = {}
local ItemsList = {"Race Reroll", "Coffin Boat", "Iceborn Headband","Legendary Fruit Chest", "Rare Fruit Chest", "Mythical Fruit Chest", "Rare Fish Bait", "Legendary Fish Bait", "Sorcerer Hunter Costume", "Powderpunk Outfit"}

for _, itemName in pairs(ItemsList) do
    local ItemBtn = Instance.new("TextButton")
    ItemBtn.Name = itemName
    ItemBtn.Parent = ComboContainer
    ItemBtn.Size = UDim2.new(1, -5, 0, 25)
    ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ItemBtn.Text = itemName
    ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ItemBtn.Font = Enum.Font.Gotham
    ItemBtn.TextSize = 12
    ItemBtn.TextWrapped = true
    Instance.new("UICorner", ItemBtn)

    ItemBtn.MouseButton1Click:Connect(function()
        if SelectedItems[itemName] then
            SelectedItems[itemName] = nil
            ItemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ItemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            SelectedItems[itemName] = true
            ItemBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            ItemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

-----------------------------------------------------------
-- %100 ÇALIŞAN IŞINLANMA + SENİN İSTEDİĞİN 40x MANTIĞI
-----------------------------------------------------------
local function openShopGhost()
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    local compassObj = ReplicatedStorage.CompassGuider:FindFirstChild("Traveling Merchant")
    if not compassObj then return end

    local targetCFrame = (typeof(compassObj.Value) == "CFrame" and compassObj.Value) or CFrame.new(compassObj.Value)
    local originalCFrame = RootPart.CFrame
    local Remote = ReplicatedStorage.Events.TravelingMerchentRemote

    -- 1. BÖLGEYİ HAZIRLA
    LocalPlayer:RequestStreamAroundAsync(targetCFrame.Position)

    -- 2. IŞINLAN (Senin %100 çalışan kodundaki gibi önce TP)
    RootPart.CFrame = targetCFrame

    -- 3. 40 KEZ GÖNDERME (Arka Planda)
    task.spawn(function()
        -- OpenShop'u 40 kere at
        for i = 1, 40 do
            task.spawn(function() pcall(function() Remote:InvokeServer("OpenShop") end) end)
            -- Seçilen itemları 40 kere at
            for itemName, _ in pairs(SelectedItems) do
                task.spawn(function() pcall(function() Remote:InvokeServer(itemName) end) end)
            end
            task.wait(0.01) -- Çok hızlı spam
        end
    end)

    -- 4. BEKLE VE GERİ DÖN (Süreyi 0.8 saniyeye çıkardık)
    task.wait(0.8) 
    RootPart.CFrame = originalCFrame
end

-----------------------------------------------------------
-- KONTROLLER
-----------------------------------------------------------
local nKey = UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.N then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

ActionButton.MouseButton1Click:Connect(openShopGhost)

CloseButton.MouseButton1Click:Connect(function()
    nameUpdaterActive = false
    nKey:Disconnect()
    ScreenGui:Destroy()
end)
