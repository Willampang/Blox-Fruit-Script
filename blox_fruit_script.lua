-- Auto-Farm Script for Blox Fruits with GUI
-- DISCLAIMER: Use at your own risk. This script is for educational purposes.

-- Variables
local autoFarmEnabled = false
local selectedNPC = nil
local attackInterval = 0.5 -- Time (in seconds) between attacks

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local DropDown = Instance.new("TextButton")
local NPCList = Instance.new("ScrollingFrame")
local StartButton = Instance.new("TextButton")
local StopButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

-- GUI Properties
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0.5, -100, 0.5, -150)
Frame.AnchorPoint = Vector2.new(0.5, 0.5) -- Center alignment for better mobile support

DropDown.Parent = Frame
DropDown.Text = "Select NPC"
DropDown.Size = UDim2.new(1, -10, 0, 30)
DropDown.Position = UDim2.new(0, 5, 0, 10)
DropDown.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
DropDown.TextScaled = true -- Scale text for readability on small screens

NPCList.Parent = Frame
NPCList.Size = UDim2.new(1, -10, 0, 150)
NPCList.Position = UDim2.new(0, 5, 0, 50)
NPCList.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
NPCList.CanvasSize = UDim2.new(0, 0, 1, 0)
NPCList.ScrollBarThickness = 8 -- Adjust scrollbar size for mobile usability

StartButton.Parent = Frame
StartButton.Text = "Start Auto-Farm"
StartButton.Size = UDim2.new(1, -10, 0, 30)
StartButton.Position = UDim2.new(0, 5, 0, 210)
StartButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
StartButton.TextScaled = true

StopButton.Parent = Frame
StopButton.Text = "Stop Auto-Farm"
StopButton.Size = UDim2.new(1, -10, 0, 30)
StopButton.Position = UDim2.new(0, 5, 0, 250)
StopButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
StopButton.TextScaled = true

CloseButton.Parent = Frame
CloseButton.Text = "Close GUI"
CloseButton.Size = UDim2.new(1, -10, 0, 30)
CloseButton.Position = UDim2.new(0, 5, 0, 290)
CloseButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
CloseButton.TextScaled = true

-- Populate NPC List
for _, npc in pairs(workspace:GetChildren()) do
    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
        local NPCButton = Instance.new("TextButton")
        NPCButton.Parent = NPCList
        NPCButton.Text = npc.Name
        NPCButton.Size = UDim2.new(1, -10, 0, 30)
        NPCButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
        NPCButton.TextScaled = true -- Scale text for mobile screens
        NPCButton.MouseButton1Click:Connect(function()
            selectedNPC = npc.Name
            DropDown.Text = "Selected: " .. npc.Name
        end)
    end
end

-- Utility Functions
local function findNPC(name)
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:IsA("Model") and npc.Name == name then
            return npc
        end
    end
    return nil
end

local function attackNPC(npc)
    if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
        -- Move to NPC
        game.Players.LocalPlayer.Character:MoveTo(npc.HumanoidRootPart.Position)
        wait(0.1)

        -- Attack
        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        else
            warn("No tool equipped for attacking.")
        end
    end
end

-- Auto-Farm Loop
local function startAutoFarm()
    autoFarmEnabled = true
    while autoFarmEnabled do
        local npc = findNPC(selectedNPC)
        if npc then
            attackNPC(npc)
        else
            print("No NPC found: " .. selectedNPC)
        end
        wait(attackInterval)
    end
end

-- Button Connections
StartButton.MouseButton1Click:Connect(function()
    if selectedNPC then
        print("Starting Auto-Farm for " .. selectedNPC .. "...")
        startAutoFarm()
    else
        warn("Please select an NPC first!")
    end
end)

StopButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = false
    print("Auto-Farm stopped.")
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    print("GUI Closed.")
end)
