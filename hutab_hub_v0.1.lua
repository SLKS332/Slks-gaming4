-- Hutad Hub v0.1 (Demo)
-- UI + Tabs + Fly + ESP Name + Distance + Anti AFK

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- ================= UI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "HutadHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 260)
main.Position = UDim2.new(0.5, -210, 0.5, -130)
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

-- ============ TAB BUTTONS ============
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(0,120,1,-30)
tabBar.Position = UDim2.new(0,0,0,30)
tabBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
tabBar.BorderSizePixel = 0

local function tabBtn(text, y)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	return b
end

local btnUpdate = tabBtn("CẬP NHẬT", 0)
local btnPlayer = tabBtn("PLAYER", 40)
local btnSetting = tabBtn("SETTING", 80)

-- ============ CONTENT FRAMES ============
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

local function showTab(tab)
	tabUpdate.Visible = false
	tabPlayer.Visible = false
	tabSetting.Visible = false
	tab.Visible = true
end
showTab(tabUpdate)

btnUpdate.MouseButton1Click:Connect(function() showTab(tabUpdate) end)
btnPlayer.MouseButton1Click:Connect(function() showTab(tabPlayer) end)
btnSetting.MouseButton1Click:Connect(function() showTab(tabSetting) end)

-- ============ TAB UPDATE ============
local uText = Instance.new("TextLabel", tabUpdate)
uText.Size = UDim2.new(1,-10,0,120)
uText.Position = UDim2.new(0,5,0,5)
uText.TextWrapped = true
uText.TextXAlignment = Left
uText.TextYAlignment = Top
uText.TextColor3 = Color3.new(1,1,1)
uText.BackgroundTransparency = 1
uText.Text =
[[HUTAD HUB v0.1 (DEMO)

- Fly (di chuyển mới bay)
- ESP: Tên + Khoảng cách
- Anti AFK

Người dùng: ]]..player.Name

-- ============ TAB PLAYER ============
local flyOn = false
local espOn = false
local speed = 5
local bv

local flyBtn = Instance.new("TextButton", tabPlayer)
flyBtn.Size = UDim2.new(0,140,0,35)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"

local espBtn = Instance.new("TextButton", tabPlayer)
espBtn.Size = UDim2.new(0,140,0,35)
espBtn.Position = UDim2.new(0,10,0,55)
espBtn.Text = "ESP: OFF"

-- Fly
flyBtn.MouseButton1Click:Connect(function()
	flyOn = not flyOn
	flyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"
	if not flyOn and bv then bv:Destroy() bv=nil end
end)

RunService.RenderStepped:Connect(function()
	if flyOn then
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			if not bv then
				bv = Instance.new("BodyVelocity", hrp)
				bv.MaxForce = Vector3.new(9e9,9e9,9e9)
			end
			bv.Velocity = hrp.AssemblyLinearVelocity
		end
	end
end)

-- ESP
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESP"

local function clearESP()
	espFolder:ClearAllChildren()
end

local function makeESP(p)
	if p == player then return end
	local bill = Instance.new("BillboardGui", espFolder)
	bill.Adornee = p.Character and p.Character:WaitForChild("Head",3)
	bill.Size = UDim2.new(0,200,0,40)
	bill.AlwaysOnTop = true

	local txt = Instance.new("TextLabel", bill)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.new(1,1,1)
	txt.TextScaled = true

	RunService.RenderStepped:Connect(function()
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local d = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
			txt.Text = p.Name.." ["..math.floor(d).."]"
		end
	end)
end

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"
	clearESP()
	if espOn then
		for _,p in pairs(Players:GetPlayers()) do
			makeESP(p)
		end
	end
end)

-- ============ TAB SETTING ============
local afkBtn = Instance.new("TextButton", tabSetting)
afkBtn.Size = UDim2.new(0,180,0,35)
afkBtn.Position = UDim2.new(0,10,0,10)
afkBtn.Text = "Anti AFK: ON"

player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(), cam.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(), cam.CFrame)
end)
