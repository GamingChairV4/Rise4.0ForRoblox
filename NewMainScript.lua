loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua", true))()

repeat task.wait() until game:IsLoaded()
repeat task.wait() until shared.GuiLibrary
local uis = game:GetService("UserInputService")
local GuiLibrary = shared.GuiLibrary
local ScriptSettings = {}
local UIS = game:GetService("UserInputService")
local COB = function(tab, argstable) 
	return GuiLibrary["ObjectsThatCanBeSaved"][tab.."Window"]["Api"].CreateOptionsButton(argstable)
end
function securefunc(func)
	task.spawn(function()
		spawn(function()
			pcall(function()
				loadstring(
					func()
				)()
			end)
		end)
	end)
end
function warnnotify(title, content, duration)
	local frame = GuiLibrary["CreateNotification"](title or "Rise 4.0", content or "(No Content Given)", duration or 5, "assets/WarningNotification.png")
	frame.Frame.Frame.ImageColor3 = Color3.fromRGB(255, 64, 64)
end
function infonotify(title, content, duration)
	local frame = GuiLibrary["CreateNotification"](title or "Rise 4.0", content or "(No Content Given)", duration or 5, "assets/InfoNotification.png")
	frame.Frame.Frame.ImageColor3 = Color3.fromRGB(255, 64, 64)
end
function risenotify(title, content, duration)
	local frame = GuiLibrary["CreateNotification"](title or "Rise 4.0", content or "(No Content Given)", duration or 5, "assets/InfoNotification.png")
	frame.Frame.Frame.ImageColor3 = Color3.fromRGB(2, 64, 64)
end
function getstate()
	local ClientStoreHandler = require(game.Players.LocalPlayer.PlayerScripts.TS.ui.store).ClientStore
	return ClientStoreHandler:getState().Game.matchState
end
function iscustommatch()
	local ClientStoreHandler = require(game.Players.LocalPlayer.PlayerScripts.TS.ui.store).ClientStore
	return ClientStoreHandler:getState().Game.customMatch
end
function checklagback()
	local hrp = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
	return isnetworkowner(hrp)
end

GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Text = "Rise V4.0 (learning)"
GuiLibrary["MainGui"].ScaledGui.ClickGui.MainWindow.TextLabel.Text = "Rise V4.0"
GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Version.Text = "Rise V4.0"
GuiLibrary["MainGui"].ScaledGui.ClickGui.Version.Position = UDim2.new(1, -175 - 20, 1, -25)
infonotify("Rise 4.0", "Loaded successfully!", 5)

risenotify("Rise 4.0", "Searching for anticheat..", 3)
task.wait(4)
risenotify("Rise 4.0", "No results for anticheat has been found.", 3)


local AutoWin1 = COB("Blatant", {
    Name = "RageAutoWin",
    HoverText = "This feature is currently disabled, but it automaticially wins the match for you.",
    Function = function(callback)
        if callback then
            pcall(function()
                risenotify("Rise 4.0", "Searching for anticheat..", 5)
            end)
        else
            pcall(function()
                print("disabled autowin")
            end)
        end
    end
})

local AutoWin1 = COB("Render", {
    Name = "Notification",
    HoverText = "Spams yourself with a ton of searching for anticheat notifications.",
    Function = function(callback)
        if callback then
            pcall(function()
                risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)
                task.wait(0.5) risenotify("Rise 4.0", "Searching for anticheat..", 5)

            end)
        else
            pcall(function()
                print("disabled autowin")
            end)
        end
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local bedNukerEnabled = false -- Initial state of bed nuker (disabled)

local function autoDamageBedsFunction()
    while bedNukerEnabled do
        local playerPosition = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position
        if playerPosition then
            local bedsFolder = workspace:WaitForChild("Map"):WaitForChild("Beds")
            local woodPick = "Wooden Pickaxe"

            local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DamageBlock")

            -- Function to find the nearest enemy bed
            local function getNearestBed()
                local nearestBed = nil
                local shortestDistance = math.huge
                local playerTeamColor = LocalPlayer.TeamColor

                for _, bed in ipairs(bedsFolder:GetChildren()) do
                    if bed:IsA("Model") and bed:FindFirstChild("Primary") and bed:FindFirstChild("Mattress") then
                        local mattress = bed.Mattress
                        if mattress.BrickColor == playerTeamColor then
                            continue -- Skip if it's the player's own bed
                        end

                        local bedPosition = bed.Primary.Position
                        local distance = (bedPosition - playerPosition).Magnitude

                        if distance < shortestDistance then
                            nearestBed = bed
                            shortestDistance = distance
                        end
                    end
                end

                return nearestBed
            end

            -- Get the nearest bed and damage it
            local nearestBed = getNearestBed()
            if nearestBed then
                local args = {
                    [1] = nearestBed, -- Target the nearest bed
                    [2] = woodPick -- Using the wooden pickaxe by default
                }
                remote:InvokeServer(unpack(args))
            end
        end
        task.wait() -- Wait between each action to avoid server overload
    end
end

-- Bed Nuker utility using the COB structure
local BedNukerUtility = COB("Utility", {
    Name = "BedNukerBWZ",
    HoverText = "Breaks beds arround you automaticially.",
    Function = function(callback)
        if callback then
            bedNukerEnabled = true -- Enable bed nuker
            pcall(function()
                infonotify("Rise 4.0", "Bed Nuker enabled", 2)
                autoDamageBedsFunction() -- Start damaging beds
            end)
        else
            bedNukerEnabled = false -- Disable bed nuker
            pcall(function()
                print("Bed Nuker Disabled")
            end)
        end
    end
})
