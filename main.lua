local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

pcall(function()
    if game.CoreGui:FindFirstChild("Impuro") then
        game.CoreGui.Impuro:Destroy()
    end
end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Impuro"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 650)
frame.Position = UDim2.new(0.5, 0, 0.2, 0)
frame.AnchorPoint = Vector2.new(0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.ZIndex = 1

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0.5, 210, 0.2, -52)
toggleBtn.AnchorPoint = Vector2.new(0.5, 0)
toggleBtn.Text = "–"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BorderSizePixel = 1
toggleBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
local guiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    frame.Visible = guiVisible
    toggleBtn.Text = guiVisible and "–" or "+"
end)

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "Impuro"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.BackgroundTransparency = 1

local versionLabel = Instance.new("TextLabel", frame)
versionLabel.Size = UDim2.new(1, 0, 0, 30)
versionLabel.Position = UDim2.new(0, 0, 1, -60)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Dumper Version"
versionLabel.Font = Enum.Font.SourceSansBold
versionLabel.TextColor3 = Color3.new(1, 1, 1)
versionLabel.TextScaled = true
versionLabel.ZIndex = 2

local smallVersion = Instance.new("TextLabel", frame)
smallVersion.Size = UDim2.new(1, 0, 0, 20)
smallVersion.Position = UDim2.new(0, 0, 1, -30)
smallVersion.BackgroundTransparency = 1
smallVersion.Text = "2.685.797"
smallVersion.Font = Enum.Font.SourceSans
smallVersion.TextColor3 = Color3.new(1, 1, 1)
smallVersion.TextScaled = false
smallVersion.TextSize = 16
smallVersion.ZIndex = 2

local yOffset = 50
local colIndex = 0
local rowIndex = 0

local function updatePosition(btn)
    local colWidth = frame.Size.X.Offset
    btn.Size = UDim2.new(0, colWidth * 0.85, 0, 50)
    btn.Position = UDim2.new(0, colWidth * 0.075, 0, yOffset + rowIndex * 60)
    rowIndex = rowIndex + 1
end

local originalDisplayName = LocalPlayer.DisplayName or LocalPlayer.Name
local protectOn = false

local function setProtect(on)
    protectOn = on
    if on then
        pcall(function()
            LocalPlayer.DisplayName = "Hidden"
        end)
    else
        pcall(function()
            LocalPlayer.DisplayName = originalDisplayName
        end)
    end
end

local espConn
local flying, flyConn
local noclipConn
local wsActive = false
local wsConn
local invisConn

local function createBtn(text, callback, hasToggle)
    local btn = Instance.new("TextButton", frame)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(200, 0, 0)
    updatePosition(btn)

    if hasToggle then
        btn.Text = text..": OFF"
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text..": "..(state and "ON" or "OFF")
            callback(state)
        end)
    else
        btn.Text = text..": OFF"
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.Text = text..": "..(active and "ON" or "OFF")
            callback(active)
        end)
    end
end

createBtn("ESP", function(on)
    if on then
        espConn = RunService.RenderStepped:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ImpuroESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ImpuroESP"
                    hl.FillColor = Color3.fromRGB(200, 0, 255)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.3
                    hl.OutlineTransparency = 0
                    hl.Adornee = p.Character
                    hl.Parent = p.Character
                end
            end
        end)
    else
        if espConn then espConn:Disconnect() espConn = nil end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("ImpuroESP")
                if hl then hl:Destroy() end
            end
        end
    end
end, true)

createBtn("Fly", function(on)
    flying = on
    if flying then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local bv = Instance.new("BodyVelocity", root)
        local bg = Instance.new("BodyGyro", root)
        bv.Name = "FlyVelocity"
        bg.Name = "FlyGyro"
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.P = 10000
        flyConn = RunService.RenderStepped:Connect(function()
            if not flying then return end
            local mv = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then mv += Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then mv -= Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then mv -= Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then mv += Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.new(0,1,0) end
            bv.Velocity = (mv.Magnitude>0 and mv.Unit*100 or Vector3.zero)
            bg.CFrame = Camera.CFrame
        end)
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        end
    end
end, true)

createBtn("NoClip", function(on)
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end, true)

createBtn("Walkspeed", function(on)
    wsActive = on
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if wsConn then wsConn:Disconnect() wsConn = nil end
    if wsActive and h then
        wsConn = RunService.RenderStepped:Connect(function()
            if h then
                h.WalkSpeed = 150
            end
        end)
    elseif h then
        h.WalkSpeed = 16
    end
end, true)

createBtn("Invisibility", function(on)
    if on then
        invisConn = RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    if part:FindFirstChild("face") then part.face:Destroy() end
                end
            end
        end)
    else
        if invisConn then invisConn:Disconnect() invisConn = nil end
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end, true)

createBtn("Protect", function(on)
    setProtect(on)
end, true)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        if UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
            gui.Enabled = not gui.Enabled
        end
    elseif input.KeyCode == Enum.KeyCode.LeftAlt then
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            gui.Enabled = not gui.Enabled
        end
    end
end)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

pcall(function()
    if game.CoreGui:FindFirstChild("Impuro") then
        game.CoreGui.Impuro:Destroy()
    end
end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Impuro"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 650)
frame.Position = UDim2.new(0.5, 0, 0.2, 0)
frame.AnchorPoint = Vector2.new(0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.ZIndex = 1

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0.5, 210, 0.2, -52)
toggleBtn.AnchorPoint = Vector2.new(0.5, 0)
toggleBtn.Text = "–"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BorderSizePixel = 1
toggleBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
local guiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    frame.Visible = guiVisible
    toggleBtn.Text = guiVisible and "–" or "+"
end)

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "Impuro"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.BackgroundTransparency = 1

local versionLabel = Instance.new("TextLabel", frame)
versionLabel.Size = UDim2.new(1, 0, 0, 30)
versionLabel.Position = UDim2.new(0, 0, 1, -60)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Dumper Version"
versionLabel.Font = Enum.Font.SourceSansBold
versionLabel.TextColor3 = Color3.new(1, 1, 1)
versionLabel.TextScaled = true
versionLabel.ZIndex = 2

local smallVersion = Instance.new("TextLabel", frame)
smallVersion.Size = UDim2.new(1, 0, 0, 20)
smallVersion.Position = UDim2.new(0, 0, 1, -30)
smallVersion.BackgroundTransparency = 1
smallVersion.Text = "2.685.797"
smallVersion.Font = Enum.Font.SourceSans
smallVersion.TextColor3 = Color3.new(1, 1, 1)
smallVersion.TextScaled = false
smallVersion.TextSize = 16
smallVersion.ZIndex = 2

local yOffset = 50
local colIndex = 0
local rowIndex = 0

local function updatePosition(btn)
    local colWidth = frame.Size.X.Offset
    btn.Size = UDim2.new(0, colWidth * 0.85, 0, 50)
    btn.Position = UDim2.new(0, colWidth * 0.075, 0, yOffset + rowIndex * 60)
    rowIndex = rowIndex + 1
end

local originalDisplayName = LocalPlayer.DisplayName or LocalPlayer.Name
local protectOn = false

local function setProtect(on)
    protectOn = on
    if on then
        pcall(function()
            LocalPlayer.DisplayName = "Hidden"
        end)
    else
        pcall(function()
            LocalPlayer.DisplayName = originalDisplayName
        end)
    end
end

local espConn
local flying, flyConn
local noclipConn
local wsActive = false
local wsConn
local invisConn

local function createBtn(text, callback, hasToggle)
    local btn = Instance.new("TextButton", frame)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(200, 0, 0)
    updatePosition(btn)

    if hasToggle then
        btn.Text = text..": OFF"
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text..": "..(state and "ON" or "OFF")
            callback(state)
        end)
    else
        btn.Text = text..": OFF"
        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.Text = text..": "..(active and "ON" or "OFF")
            callback(active)
        end)
    end
end

createBtn("ESP", function(on)
    if on then
        espConn = RunService.RenderStepped:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("ImpuroESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ImpuroESP"
                    hl.FillColor = Color3.fromRGB(200, 0, 255)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.FillTransparency = 0.3
                    hl.OutlineTransparency = 0
                    hl.Adornee = p.Character
                    hl.Parent = p.Character
                end
            end
        end)
    else
        if espConn then espConn:Disconnect() espConn = nil end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("ImpuroESP")
                if hl then hl:Destroy() end
            end
        end
    end
end, true)

createBtn("Fly", function(on)
    flying = on
    if flying then
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local bv = Instance.new("BodyVelocity", root)
        local bg = Instance.new("BodyGyro", root)
        bv.Name = "FlyVelocity"
        bg.Name = "FlyGyro"
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.P = 10000
        flyConn = RunService.RenderStepped:Connect(function()
            if not flying then return end
            local mv = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then mv += Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then mv -= Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then mv -= Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then mv += Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.new(0,1,0) end
            bv.Velocity = (mv.Magnitude>0 and mv.Unit*100 or Vector3.zero)
            bg.CFrame = Camera.CFrame
        end)
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        end
    end
end, true)

createBtn("NoClip", function(on)
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end, true)

createBtn("Walkspeed", function(on)
    wsActive = on
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if wsConn then wsConn:Disconnect() wsConn = nil end
    if wsActive and h then
        wsConn = RunService.RenderStepped:Connect(function()
            if h then
                h.WalkSpeed = 150
            end
        end)
    elseif h then
        h.WalkSpeed = 16
    end
end, true)

createBtn("Invisibility", function(on)
    if on then
        invisConn = RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    if part:FindFirstChild("face") then part.face:Destroy() end
                end
            end
        end)
    else
        if invisConn then invisConn:Disconnect() invisConn = nil end
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end, true)

createBtn("Protect", function(on)
    setProtect(on)
end, true)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        if UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
            gui.Enabled = not gui.Enabled
        end
    elseif input.KeyCode == Enum.KeyCode.LeftAlt then
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            gui.Enabled = not gui.Enabled
        end
    end
end)
