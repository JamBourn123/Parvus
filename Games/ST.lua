local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LocalPlayer = PlayerService.LocalPlayer
local Ping = Stats.Network.ServerStatsItem["Data Ping"]
local Aimbot,SilentAim = false,nil

local Window = Parvus.Utilities.UI:Window({
    Name = "Parvus Hub — "..Parvus.Current,
    Position = UDim2.new(0.05,0,0.5,-248),
    Size = UDim2.new(0,496,0,496)
    }) do Window:Watermark({Enabled = true})

    local GameTab = Window:Tab({Name = Parvus.Current}) do
        local FlySection = GameTab:Section({Name = "Fly",Side = "Right"}) do
            FlySection:Toggle({Name = "Enabled",Flag = "ST/Fly/Enabled",Value = false})
            :Keybind({Flag = "ST/Fly/Keybind"})
            FlySection:Toggle({Name = "Attach To Camera",Flag = "ST/Fly/Camera",Value = true})
            FlySection:Slider({Name = "Speed",Flag = "ST/Fly/Speed",Min = 10,Max = 500,Value = 100})
        end
    end
    local VisualsTab = Window:Tab({Name = "Visuals"}) do
        local GlobalSection = VisualsTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Colorpicker({Name = "Ally Color",Flag = "ESP/Player/Ally",Value = {0.33333334326744,0.75,1,0,false}})
            GlobalSection:Colorpicker({Name = "Enemy Color",Flag = "ESP/Player/Enemy",Value = {1,0.75,1,0,false}})
            GlobalSection:Toggle({Name = "Team Check",Flag = "ESP/Player/TeamCheck",Value = false})
            GlobalSection:Toggle({Name = "Use Team Color",Flag = "ESP/Player/TeamColor",Value = false})
        end
        local BoxSection = VisualsTab:Section({Name = "Boxes",Side = "Left"}) do
            BoxSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Box/Enabled",Value = false})
            BoxSection:Toggle({Name = "Filled",Flag = "ESP/Player/Box/Filled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/Player/Box/Outline",Value = true})
            BoxSection:Slider({Name = "Thickness",Flag = "ESP/Player/Box/Thickness",Min = 1,Max = 10,Value = 1})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/Player/Box/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            BoxSection:Divider({Text = "Text / Info"})
            BoxSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Text/Enabled",Value = false})
            BoxSection:Toggle({Name = "Outline",Flag = "ESP/Player/Text/Outline",Value = true})
            BoxSection:Toggle({Name = "Autoscale",Flag = "ESP/Player/Text/Autoscale",Value = true})
            BoxSection:Dropdown({Name = "Font",Flag = "ESP/Player/Text/Font",List = {
                {Name = "UI",Mode = "Button"},
                {Name = "System",Mode = "Button"},
                {Name = "Plex",Mode = "Button"},
                {Name = "Monospace",Mode = "Button",Value = true}
            }})
            BoxSection:Slider({Name = "Size",Flag = "ESP/Player/Text/Size",Min = 13,Max = 100,Value = 16})
            BoxSection:Slider({Name = "Transparency",Flag = "ESP/Player/Text/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local OoVSection = VisualsTab:Section({Name = "Offscreen Arrows",Side = "Left"}) do
            OoVSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Arrow/Enabled",Value = false})
            OoVSection:Toggle({Name = "Filled",Flag = "ESP/Player/Arrow/Filled",Value = true})
            OoVSection:Slider({Name = "Width",Flag = "ESP/Player/Arrow/Width",Min = 14,Max = 28,Value = 18})
            OoVSection:Slider({Name = "Height",Flag = "ESP/Player/Arrow/Height",Min = 14,Max = 28,Value = 28})
            OoVSection:Slider({Name = "Distance From Center",Flag = "ESP/Player/Arrow/Distance",Min = 80,Max = 200,Value = 200})
            OoVSection:Slider({Name = "Thickness",Flag = "ESP/Player/Arrow/Thickness",Min = 1,Max = 10,Value = 1})
            OoVSection:Slider({Name = "Transparency",Flag = "ESP/Player/Arrow/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
        end
        local HighlightSection = VisualsTab:Section({Name = "Highlights",Side = "Right"}) do
            HighlightSection:Toggle({Name = "Enabled",Flag = "ESP/Player/Highlight/Enabled",Value = false})
            HighlightSection:Slider({Name = "Transparency",Flag = "ESP/Player/Highlight/Transparency",Min = 0,Max = 1,Precise = 2,Value = 0})
            HighlightSection:Colorpicker({Name = "Outline Color",Flag = "ESP/Player/Highlight/OutlineColor",Value = {1,1,0,0.5,false}})
        end
    end
    local SettingsTab = Window:Tab({Name = "Settings"}) do
        local MenuSection = SettingsTab:Section({Name = "Menu",Side = "Left"}) do
            MenuSection:Toggle({Name = "Enabled",Flag = "UI/Toggle",IgnoreFlag = true,Value = Window.Enabled,
            Callback = function(Bool) Window:Toggle(Bool) end}):Keybind({Value = "RightShift",Flag = "UI/Keybind",DoNotClear = true})
            MenuSection:Toggle({Name = "Open On Load",Flag = "UI/OOL",Value = true})
            MenuSection:Toggle({Name = "Blur Gameplay",Flag = "UI/Blur",Value = false,
            Callback = function() Window:Toggle(Window.Enabled) end})
            MenuSection:Toggle({Name = "Watermark",Flag = "UI/Watermark",Value = true,
            Callback = function(Bool) Window.Watermark:Toggle(Bool) end})
            MenuSection:Toggle({Name = "Custom Mouse",Flag = "Mouse/Enabled",Value = false})
            MenuSection:Colorpicker({Name = "Color",Flag = "UI/Color",Value = {1,0.25,1,0,true},
            Callback = function(HSVAR,Color) Window:SetColor(Color) end})
        end
        SettingsTab:AddConfigSection("Left")
        SettingsTab:Button({Name = "Rejoin",Side = "Left",
        Callback = Parvus.Utilities.Misc.ReJoin})
        SettingsTab:Button({Name = "Server Hop",Side = "Left",
        Callback = Parvus.Utilities.Misc.ServerHop})
        SettingsTab:Button({Name = "Join Discord Server",Side = "Left",
        Callback = Parvus.Utilities.Misc.JoinDiscord})
        :ToolTip("Join for support, updates and more!")
        local BackgroundSection = SettingsTab:Section({Name = "Background",Side = "Right"}) do
            BackgroundSection:Dropdown({Name = "Image",Flag = "Background/Image",List = {
                {Name = "Legacy",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://2151741365"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Hearts",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073763717"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Abstract",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073743871"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Hexagon",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073628839"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Circles",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071579801"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Lace With Flowers",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071575925"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Floral",Mode = "Button",Value = true,Callback = function()
                    Window.Background.Image = "rbxassetid://5553946656"
                    Window.Flags["Background/CustomImage"] = ""
                end}
            }})
            BackgroundSection:Textbox({Name = "Custom Image",Flag = "Background/CustomImage",Placeholder = "ImageId",
            Callback = function(String)
                if string.gsub(String," ","") ~= "" then
                    Window.Background.Image = "rbxassetid://" .. String
                end
            end})
            BackgroundSection:Colorpicker({Name = "Color",Flag = "Background/Color",Value = {1,1,0,0,false},
            Callback = function(HSVAR,Color)
                Window.Background.ImageColor3 = Color
                Window.Background.ImageTransparency = HSVAR[4]
            end})
            BackgroundSection:Slider({Name = "Tile Offset",Flag = "Background/Offset",Min = 74, Max = 296,Value = 74,
            Callback = function(Number)
                Window.Background.TileSize = UDim2.new(0,Number,0,Number)
            end})
        end
        local CrosshairSection = SettingsTab:Section({Name = "Custom Crosshair",Side = "Right"}) do
            CrosshairSection:Toggle({Name = "Enabled",Flag = "Mouse/Crosshair/Enabled",Value = false})
            CrosshairSection:Colorpicker({Name = "Color",Flag = "Mouse/Crosshair/Color",Value = {1,1,1,0,false}})
            CrosshairSection:Slider({Name = "Size",Flag = "Mouse/Crosshair/Size",Min = 0,Max = 20,Value = 4})
            CrosshairSection:Slider({Name = "Gap",Flag = "Mouse/Crosshair/Gap",Min = 0,Max = 10,Value = 2})
        end
        local CreditsSection = SettingsTab:Section({Name = "Credits",Side = "Right"}) do
            CreditsSection:Label({Text = "This script was made by AlexR32#0157"})
            CreditsSection:Divider()
            CreditsSection:Label({Text = "Thanks to Jan for awesome Background Patterns"})
            CreditsSection:Label({Text = "Thanks to Infinite Yield Team for Server Hop and Rejoin"})
            CreditsSection:Label({Text = "Thanks to Blissful for Offscreen Arrows"})
            CreditsSection:Label({Text = "Thanks to coasts for Universal ESP"})
            CreditsSection:Label({Text = "Thanks to el3tric for Bracket V2"})
            CreditsSection:Label({Text = "❤️ ❤️ ❤️ ❤️"})
        end
    end
end

Window:LoadDefaultConfig()
Window:SetValue("UI/Toggle",
Window.Flags["UI/OOL"])

local GetFPS = Parvus.Utilities.Misc:SetupFPS()
Parvus.Utilities.Drawing:Cursor(Window.Flags)

local MaxVector = Vector3.new(math.huge,math.huge,math.huge)
local BodyVelocity = Instance.new("BodyVelocity")
local BodyGyro = Instance.new("BodyGyro")
BodyGyro.P = 50000

local function GetPlayerTank(Player)
    local Char = Player:WaitForChild("Char")
    if not Char then return end
    if not Char.Value then return end
    return Char.Value.Parent.Parent.Parent
end

local function InputToVelocity()
    local Camera = Workspace.CurrentCamera
    local Velocities = {}

    Velocities[1] = UserInputService:IsKeyDown(Enum.KeyCode.W)
    and Camera.CFrame.LookVector or Vector3.zero
    Velocities[2] = UserInputService:IsKeyDown(Enum.KeyCode.S)
    and -Camera.CFrame.LookVector or Vector3.zero
    Velocities[3] = UserInputService:IsKeyDown(Enum.KeyCode.A)
    and -Camera.CFrame.RightVector or Vector3.zero
    Velocities[4] = UserInputService:IsKeyDown(Enum.KeyCode.D)
    and Camera.CFrame.RightVector or Vector3.zero
    Velocities[5] = UserInputService:IsKeyDown(Enum.KeyCode.Space)
    and Vector3.new(0,1,0) or Vector3.zero
    Velocities[6] = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
    and Vector3.new(0,-1,0) or Vector3.zero
    
    return (
        Velocities[1] +
        Velocities[2] +
        Velocities[3] +
        Velocities[4] +
        Velocities[5] +
        Velocities[6]
    )
end
local function PlayerFly(Config)
    if not Config.Enabled then
        BodyVelocity.MaxForce = Vector3.zero
        BodyGyro.MaxTorque = Vector3.zero
        return
    end
    local LPTank = GetPlayerTank(LocalPlayer)
    local Camera = Workspace.CurrentCamera
    if LPTank and LPTank.PrimaryPart then
        if Config.Camera then
            BodyGyro.Parent = LPTank.PrimaryPart
            BodyGyro.MaxTorque = MaxVector
            BodyGyro.CFrame = Camera.CFrame
        else BodyGyro.MaxTorque = Vector3.zero end
        BodyVelocity.Parent = LPTank.PrimaryPart
        BodyVelocity.MaxForce = MaxVector
        BodyVelocity.Velocity = InputToVelocity() * Config.Speed
    end
end

RunService.Heartbeat:Connect(function()
    if Window.Flags["UI/Watermark"] then
        Window.Watermark:SetTitle(string.format(
            "Parvus Hub    %s    %i FPS    %i MS",
            os.date("%X"),GetFPS(),math.round(Ping:GetValue())
        ))
    end

    PlayerFly({
        Enabled = Window.Flags["ST/Fly/Enabled"],
        Camera = Window.Flags["ST/Fly/Camera"],
        Speed = Window.Flags["ST/Fly/Speed"]
    })
end)

for Index,Player in pairs(PlayerService:GetPlayers()) do
    if Player ~= LocalPlayer then
        Parvus.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
    end
end
PlayerService.PlayerAdded:Connect(function(Player)
    Parvus.Utilities.Drawing:AddESP(Player,"Player","ESP/Player",Window.Flags)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
    Parvus.Utilities.Drawing:RemoveESP(Player)
end)