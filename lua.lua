local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local originalSizes = {}
local debounce = false

local specificRaces = { 
    "110 METER HURDLES",
    "200 METER DASH"
}

local function fuckline(part)
    local outline = Instance.new("SelectionBox")
    outline.Parent = part
    outline.Adornee = part
    outline.LineThickness = 0.1  
    outline.Color3 = Color3.new(0, 0, 1) 
end

local function adjustHitbox()
    local titleText = Workspace.Map.Timers.Timer.Title.SurfaceGui.TitleText

    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Part") then
            if v.Name == "EndPoint" or v.Name:match("^Checkpoint%d+$") then
                if v.Name == "EndPoint" then
                    v.Transparency = 0.9
                    fuckline(v)  
                end

                if not originalSizes[v] then
                    originalSizes[v] = v.Size
                end

                local targetSize -- lower the values if you encounter a ban.
                if titleText.Text == "300 METER DASH" then
                    targetSize = Vector3.new(v.Size.X, v.Size.Y, 300)
                elseif titleText.Text == "60 METER DASH" then
                    targetSize = Vector3.new(v.Size.X, v.Size.Y, 80)
                elseif titleText.Text == "100 METER DASH" then
                    targetSize = Vector3.new(v.Size.X, v.Size.Y, 85)
                elseif table.find(specificRaces, titleText.Text) then
                    targetSize = Vector3.new(v.Size.X, v.Size.Y, 105)
                elseif titleText.Text:find("RELAY") then
                    targetSize = Vector3.new(v.Size.X, v.Size.Y, 85)
                else
                    targetSize = Vector3.new(v.Size.X, v.Size.Y, 400)
                end

                if v.Size ~= targetSize then
                    v.Size = targetSize
                    v.CanCollide = false
                end
            elseif v.Name == "LandingPad" then -- useless.
                local targetSize = Vector3.new(v.Size.X, 400, v.Size.Z)

                if v.Size ~= targetSize then
                    v.Size = targetSize
                    v.CanCollide = false
                end
            end
        end
    end
end

local function onDescendantAdded(descendant)
    if debounce then return end
    debounce = true
    wait(0.5)
    adjustHitbox()
    debounce = false
end

Workspace.DescendantAdded:Connect(onDescendantAdded)
