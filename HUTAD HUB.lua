-- HUTAD HUB v0.1 DEMO | MOBILE (DELTA)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ================= LOADING =================
local gui = Instance.new("ScreenGui")
gui.Name = "HutadHub"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local loadFrame = Instance.new("Frame", gui)
loadFrame.Size = UDim2.new(0,280,0,120)
loadFrame.Position = UDim2.new(0.5,-140,0.5,-60)
loadFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
loadFrame.BorderSizePixel = 0
loadFrame.ZIndex = 50

local loadText = Instance.new("TextLabel", loadFrame)
loadText.Size = UDim2.new(1,0,0,40)
loadText.Text = "HUTAD HUB\nLoading..."
loadText.TextColor3 = Color3.new(1,1,1)
loadText.BackgroundTransparency = 1
loadText.TextScaled = true
loadText.ZIndex = 51

local barBg = Instance.new("Frame", loadFrame)
barBg.Size = UDim2.new(0.9,0,0,14)
barBg.Position = UDim2.new(0.05,0,0.65,0)
barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBg.BorderSizePixel = 0
barBg.ZIndex = 51

local bar = Instance.new("Frame", barBg)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.BorderSizePixel = 0
bar.ZIndex = 52

for i=1,100 do
	bar.Size = UDim2.new(i/100,0,1,0)
	task.wait(0.015)
end
loadFrame:Destroy()

-- ================= MAIN UI =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,440,0,260)
main.Position = UDim2.new(0.5,-220,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ZIndex = 10

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "HUTAD HUB | v0.1 DEMO"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.BorderSizePixel = 0
title.ZIndex = 11

local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(0,120,1,-30)
tabBar.Position = UDim2.new(0,0,0,30)
tabBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 11

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-120,1,-30)
content.Position = UDim2.new(0,120,0,30)
content.BackgroundTransparency = 1
content.ZIndex = 11

local function newTab()
	local f = Instance.new("Frame", content)
	f.Size = UDim2.new(1,0,1,0)
	f.Visible = false
	f.BackgroundTransparency = 1
	f.ZIndex = 12
	return f
end

local tabUpdate = newTab()
local tabPlayer = newTab()
local tabSetting = newTab()

local function showTab(tab)
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("Frame") then v.Visible = false end
	end
	tab.Visible = true
end

local function tabBtn(text,y)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	b.ZIndex = 12
	return b
end

tabBtn("CẬP NHẬT",0).MouseButton1Click:Connect(function() showTab(tabUpdate) end)
tabBtn("PLAYER",40).MouseButton1Click:Connect(function() showTab(tabPlayer) end)
tabBtn("SETTING",80).MouseButton1Click:Connect(function() showTab(tabSetting) end)

showTab(tabUpdate)

-- ============ UPDATE TAB ============
local info = Instance.new("TextLabel", tabUpdate)
info.Size = UDim2.new(1,-20,0,160)
info.Position = UDim2.new(0,10,0,10)
info.TextWrapped = true
info.TextXAlignment = Left
info.TextYAlignment = Top
info.TextColor3 = Color3.new(1,1,1)
info.BackgroundTransparency = 1
info.Text =
"HUTAD HUB v0.1 (DEMO)\n\n"..
"- Fly (di chuyển mới bay)\n"..
"- ESP: Tên + Khoảng cách\n"..
"- Anti AFK\n\nUser: "..player.Name

-- ============ PLAYER TAB ============
local fly = false
local esp = false
local bv

local flyBtn = Instance.new("TextButton", tabPlayer)
flyBtn.Size = UDim2.new(0,160,0,36)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
	if not fly and bv then bv:Destroy() bv=nil end
end)

RunService.RenderStepped:Connect(function()
	if fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		if not bv then
			bv = Instance.new("BodyVelocity", hrp)
			bv.MaxForce = Vector3.new(1e9,1e9,1e9)
		end
		bv.Velocity = hrp.AssemblyLinearVelocity
	end
end)

-- ESP
local espFolder = Instance.new("Folder", gui)

local function clearESP()
	espFolder:ClearAllChildren()
end

local function addESP(p)
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
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local d = (player.Character.HumanoidRootPart.Position -
				p.Character.HumanoidRootPart.Position).Magnitude
			txt.Text = p.Name.." ["..math.floor(d).."]"
		end
	end)
end

local espBtn = Instance.new("TextButton", tabPlayer)
espBtn.Size = UDim2.new(0,160,0,36)
espBtn.Position = UDim2.new(0,10,0,55)
espBtn.Text = "ESP: OFF"

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = esp and "ESP: ON" or "ESP: OFF"
	clearESP()
	if esp then
		for _,p in pairs(Players:GetPlayers()) do addESP(p) end
	end
end)

-- ============ SETTING TAB ============
local antiAfk = true

local afkBtn = Instance.new("TextButton", tabSetting)
afkBtn.Size = UDim2.new(0,180,0,36)
afkBtn.Position = UDim2.new(0,10,0,10)
afkBtn.Text = "Anti AFK: ON"

afkBtn.MouseButton1Click:Connect(function()
	antiAfk = not antiAfk
	afkBtn.Text = antiAfk and "Anti AFK: ON" or "Anti AFK: OFF"
end)

player.Idled:Connect(function()
	if antiAfk then
		VirtualUser:Button2Down(Vector2.new(), camera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(), camera.CFrame)
	end
end)
