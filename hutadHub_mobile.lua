-- HUTAD HUB v0.2 FULL | DELTA MOBILE
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HutadHub"
gui.ResetOnSpawn = false

-- ================= LOADING =================
local load = Instance.new("Frame", gui)
load.Size = UDim2.new(0,280,0,120)
load.Position = UDim2.new(0.5,-140,0.5,-60)
load.BackgroundColor3 = Color3.fromRGB(25,25,25)
load.BorderSizePixel = 0
load.ZIndex = 50

local ltext = Instance.new("TextLabel", load)
ltext.Size = UDim2.new(1,0,0,40)
ltext.Text = "HUTAD HUB\nLoading..."
ltext.TextColor3 = Color3.new(1,1,1)
ltext.BackgroundTransparency = 1
ltext.TextScaled = true

local bg = Instance.new("Frame", load)
bg.Size = UDim2.new(0.9,0,0,14)
bg.Position = UDim2.new(0.05,0,0.65,0)
bg.BackgroundColor3 = Color3.fromRGB(40,40,40)
bg.BorderSizePixel = 0

local bar = Instance.new("Frame", bg)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.Size = UDim2.new(0,0,1,0)

for i=1,100 do
	bar.Size = UDim2.new(i/100,0,1,0)
	task.wait(0.01)
end
load:Destroy()

-- ================= MAIN UI =================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,440,0,260)
main.Position = UDim2.new(0.5,-220,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "HUTAD HUB | v0.2 FULL"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.BorderSizePixel = 0

-- MINIMIZE
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,0)
minBtn.Text = "-"
minBtn.TextScaled = true
minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BorderSizePixel = 0

local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0,50,0,50)
mini.Position = UDim2.new(1,-60,0.5,-25)
mini.Text = "H"
mini.TextScaled = true
mini.BackgroundColor3 = Color3.fromRGB(0,170,255)
mini.TextColor3 = Color3.new(1,1,1)
mini.BorderSizePixel = 0
mini.Visible = false
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

minBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	main.Visible = true
	mini.Visible = false
end)

-- ================= TABS =================
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(0,120,1,-30)
tabBar.Position = UDim2.new(0,0,0,30)
tabBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
tabBar.BorderSizePixel = 0

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-120,1,-30)
content.Position = UDim2.new(0,120,0,30)
content.BackgroundTransparency = 1

local function newTab()
	local f = Instance.new("Frame", content)
	f.Size = UDim2.new(1,0,1,0)
	f.Visible = false
	f.BackgroundTransparency = 1
	return f
end

local tabUpdate = newTab()
local tabPlayer = newTab()
local tabSetting = newTab()

local function showTab(t)
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("Frame") then v.Visible=false end
	end
	t.Visible = true
end

local function tabBtn(txt,y)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(1,0,0,40)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = txt
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	b.MouseButton1Click:Connect(function()
		showTab(txt=="CẬP NHẬT" and tabUpdate or txt=="PLAYER" and tabPlayer or tabSetting)
	end)
end

tabBtn("CẬP NHẬT",0)
tabBtn("PLAYER",40)
tabBtn("SETTING",80)
showTab(tabUpdate)

-- ================= UPDATE =================
local info = Instance.new("TextLabel", tabUpdate)
info.Size = UDim2.new(1,-20,0,160)
info.Position = UDim2.new(0,10,0,10)
info.TextWrapped = true
info.TextXAlignment = Left
info.TextYAlignment = Top
info.TextColor3 = Color3.new(1,1,1)
info.BackgroundTransparency = 1
info.Text =
"HUTAD HUB v0.2 FULL\n\n"..
"- Fly + Speed 1-10\n"..
"- ESP Name + Distance\n"..
"- Anti AFK\n\nUser: "..player.Name

-- ================= PLAYER =================
local fly=false
local speed=5
local bv

local flyBtn = Instance.new("TextButton", tabPlayer)
flyBtn.Size = UDim2.new(0,160,0,35)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"

flyBtn.MouseButton1Click:Connect(function()
	fly=not fly
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
		bv.Velocity = camera.CFrame.LookVector * (speed*20)
	end
end)

-- ================= SETTING =================
local anti=true
local afkBtn = Instance.new("TextButton", tabSetting)
afkBtn.Size = UDim2.new(0,180,0,35)
afkBtn.Position = UDim2.new(0,10,0,10)
afkBtn.Text = "Anti AFK: ON"

afkBtn.MouseButton1Click:Connect(function()
	anti=not anti
	afkBtn.Text = anti and "Anti AFK: ON" or "Anti AFK: OFF"
end)

player.Idled:Connect(function()
	if anti then
		VirtualUser:Button2Down(Vector2.new(), camera.CFrame)
		task.wait(1)
		VirtualUser:Button2Up(Vector2.new(), camera.CFrame)
	end
end)
