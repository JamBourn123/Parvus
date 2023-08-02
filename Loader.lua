repeat task.wait() until game.IsLoaded
repeat task.wait() until game.GameId ~= 0

local Parvus = getgenv().Parvus
if Parvus and Parvus.Loaded then
    Parvus.Utilities.UI:Notification({
        Title = "Parvus Hub",
        Description = "Script already running!",
        Duration = 5
    })
    return
end

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

local Branch, NotificationTime, IsLocal = ...

local function GetFile(File)
    return IsLocal and readfile("Parvus/" .. File) or game:HttpGet(("%s%s"):format(Parvus.Source, File))
end

local function LoadScript(Script)
    return loadstring(GetFile(Script .. ".lua"), Script)()
end

local function GetGameInfo()
    for Id, Info in pairs(Parvus.Games) do
        if tostring(game.GameId) == Id then
            return Info
        end
    end
    return Parvus.Games.Universal
end

getgenv().Parvus = {
    Source = "https://raw.githubusercontent.com/JamBourn123/Parvus/" .. Branch .. "/",
    Games = {
        ["Universal"] = {Name = "Universal", Script = "Universal"},
        ["1168263273"] = {Name = "Bad Business", Script = "Games/BB"},
        ["3360073263"] = {Name = "Bad Business PTR", Script = "Games/BB"},
        ["1586272220"] = {Name = "Steel Titans", Script = "Games/ST"},
        ["580765040"] = {Name = "RAGDOLL UNIVERSE", Script = "Games/RU"},
        ["187796008"] = {Name = "Those Who Remain", Script = "Games/TWR"},
        --["358276974" ] = {Name = "Apocalypse Rising 2",       Script = "Games/AR2" },
        --["3495983524"] = {Name = "Apocalypse Rising 2 Dev.",  Script = "Games/AR2" },
        ["1054526971"] = {Name = "Blackhawk Rescue Mission 5", Script = "Games/BRM5"}
    }
}

Parvus.Utilities = LoadScript("Utilities/Main")
Parvus.Utilities.UI = LoadScript("Utilities/UI")
Parvus.Utilities.Physics = LoadScript("Utilities/Physics")
Parvus.Utilities.Drawing = LoadScript("Utilities/Drawing")

Parvus.Cursor = GetFile("Utilities/ArrowCursor.png")
Parvus.Loadstring = GetFile("Utilities/Loadstring")
Parvus.Loadstring = Parvus.Loadstring:format(Parvus.Source, Branch, NotificationTime, tostring(IsLocal))

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
        syn.queue_on_teleport(Parvus.Loadstring)
    end
end)

Parvus.Game = GetGameInfo()
LoadScript(Parvus.Game.Script)
Parvus.Utilities.UI:Notification({
    Title = "Parvus Hub",
    Description = Parvus.Game.Name .. " loaded!",
    Duration = NotificationTime
})
Parvus.Loaded = true
