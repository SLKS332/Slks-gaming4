-- Hutad Hub v0.1 (Demo)
-- Tabs + Fly (move to fly) + ESP Name/Distance + Anti AFK

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- ================= UI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "HutadHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,420,0,260)
main.Position = UDim2.new(0.5,-210,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "HUTAD HUB v0.1 (DEMO)"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.BorderSizePixel = 0

-- ================= TAB BAR =================
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(0,120,1,-30)
tabBar.Position = UDim2.new(0,0,0,30)
tabBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
tabBar.BorderSizePixel = 0

local function tabBtn(text,y)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	return b
end

local btnUpdate = tabBtn("CẬP NHẬT",0)
local btnPlayer = tabBtn("PLAYER",40)
local btnSetting = tabBtn("SETTING",80)

-- ================= CONTENT =================
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-120,1,-30)
content.Position = UDim2.new(0,120,0,30)
content.BackgroundTransparency = 1

local function makeTab()
	local f = Instance.new("Frame", content)
	f.Size = UDim2.new(1,0,1,0)
	f.Visible = false
	f.BackgroundTransparency = 1
	return f
end

local tabUpdate = makeTab()
local tabPlayer = makeTab()
local tabSetting = makeTab()

local function showTab(t)
	tabUpdate.Visible = false
	tabPlayer.Visible = false
	tabSetting.Visible = false
	t.Visible = true
end
showTab(tabUpdate)

btnUpdate.MouseButton1Click:Connect(function() showTab(tabUpdate) end)
btnPlayer.MouseButton1Click:Connect(function() showTab(tabPlayer) end)
btnSetting.MouseButton1Click:Connect(function() showTab(tabSetting) end)

-- ================= TAB UPDATE =================
local info = Instance.new("TextLabel", tabUpdate)
info.Size = UDim2.new(1,-10,0,120)
info.Position = UDim2.new(0,5,0,5)
info.BackgroundTransparency = 1
info.TextWrapped = true
info.TextXAlignment = Left
info.TextYAlignment = Top
info.TextColor3 = Color3.new(1,1,1)
info.Text = [[
HUTAD HUB v0.1 (DEMO)

• Fly (di chuyển mới bay)
• ESP: Name / Distance
• Anti AFK

User: ]]..player.Name

-- ================= TAB PLAYER =================
local flyOn = false
local flySpeed = 5
local bv

local flyBtn = Instance.new("TextButton", tabPlayer)
flyBtn.Size = UDim2.new(0,160,0,35)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"

local espNameOn = false
local espDistOn = false

local espNameBtn = Instance.new("TextButton", tabPlayer)
espNameBtn.Size = UDim2.new(0,160,0,35)
espNameBtn.Position = UDim2.new(0,10,0,55)
espNameBtn.Text = "ESP Name: OFF"

local espDistBtn = Instance.new("TextButton", tabPlayer)
espDistBtn.Size = UDim2.new(0,160,0,35)
espDistBtn.Position = UDim2.new(0,10,0,100)
espDistBtn.Text = "ESP Distance: OFF"

-- ===== Fly logic =====
flyBtn.MouseButton1Click:Connect(function()
	flyOn = not flyOn
	flyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"
	if not flyOn and bv then bv:Destroy() bv=nil end
end)

RunService.RenderStepped:Connect(function()
	if not flyOn then return end
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if not bv then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	end

	local move = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end

	bv.Velocity = move.Unit * flySpeed
end)

-- ===== ESP =====
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESP"

local function clearESP()
	espFolder:ClearAllChildren()
end

RunService.RenderStepped:Connect(function()
	clearESP()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
			local bill = Instance.new("BillboardGui", espFolder)
			bill.Adornee = p.Character.Head
			bill.Size = UDim2.new(0,200,0,30)
			bill.AlwaysOnTop = true

			local txt = Instance.new("TextLabel", bill)
			txt.Size = UDim2.new(1,0,1,0)
			txt.BackgroundTransparency = 1
			txt.TextColor3 = Color3.new(1,1,1)
			txt.TextScaled = true

			local text = ""
			if espNameOn then text ..= p.Name end
			if espDistOn and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local d = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
				text ..= " ["..math.floor(d).."]"
			end
			txt.Text = text
		end
	end
end)

espNameBtn.MouseButton1Click:Connect(function()
	espNameOn = not espNameOn
	espNameBtn.Text = espNameOn and "ESP Name: ON" or "ESP Name: OFF"
end)

espDistBtn.MouseButton1Click:Connect(function()
	espDistOn = not espDistOn
	espDistBtn.Text = espDistOn and "ESP Distance: ON" or "ESP Distance: OFF"
end)

-- ================= TAB SETTING =================
local afkBtn = Instance.new("TextButton", tabSetting)
afkBtn.Size = UDim2.new(0,180,0,35)
afkBtn.Position = UDim2.new(0,10,0,10)
afkBtn.Text = "Anti AFK: ON"

player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(), cam.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(), cam.CFrame)
end)
