--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.
if getgenv and not getgenv().shared then getgenv().shared = {} end
local errorPopupShown = false
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end

local function displayErrorPopup(text, func)
	local oldidentity = getidentity()
	setidentity(8)
	local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
	local prompt = ErrorPrompt.new("Default")
	prompt._hideErrorCode = true
	local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	prompt:setErrorTitle("rise")
	prompt:updateButtons({{
		Text = "OK",
		Callback = function() 
			prompt:_close() 
			if func then func() end
		end,
		Primary = true
	}}, 'Default')
	prompt:setParent(gui)
	prompt:_open(text)
	setidentity(oldidentity)
end

local function riseGithubRequest(scripturl)
	if not isfile("rise/"..scripturl) then
		local suc, res
		task.delay(15, function()
			if not res and not errorPopupShown then 
				errorPopupShown = true
				displayErrorPopup("The connection to github is taking a while, Please be patient.")
			end
		end)
		suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/GamingChairV4/Rise4.0ForRoblox/"..readfile("rise/commithash.txt").."/"..scripturl, true) end)
		if not suc or res == "404: Not Found" then
			if identifyexecutor and ({identifyexecutor()})[1] == 'Wave' then 
				displayErrorPopup('Stop using detected garbage, rise will not work on such garabge until they fix BOTH HttpGet & file functions.')
				error(res)
			end
			displayErrorPopup("Failed to connect to github : rise/"..scripturl.." : "..res)
			error(res)
		end
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("rise/"..scripturl, res)
	end
	return readfile("rise/"..scripturl)
end

if not shared.riseDeveloper then 
	local commit = "main"
	for i,v in pairs(game:HttpGet("https://github.com/GamingChairV4/Rise4.0ForRoblox"):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			commit = str:sub(0, str:find('"') - 1)
			break
		end
	end
	if commit then
		if isfolder("rise") then 
			if ((not isfile("rise/commithash.txt")) or (readfile("rise/commithash.txt") ~= commit or commit == "main")) then
				for i,v in pairs({"rise/Universal.lua", "rise/MainScript.lua", "rise/GuiLibrary.lua"}) do 
					if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
						delfile(v)
					end 
				end
				if isfolder("rise/CustomModules") then 
					for i,v in pairs(listfiles("rise/CustomModules")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
							delfile(v)
						end 
					end
				end
				if isfolder("rise/Libraries") then 
					for i,v in pairs(listfiles("rise/Libraries")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
							delfile(v)
						end 
					end
				end
				writefile("rise/commithash.txt", commit)
			end
		else
			makefolder("rise")
			writefile("rise/commithash.txt", commit)
		end
	else
		displayErrorPopup("Failed to connect to github, please try using a VPN.")
		error("Failed to connect to github, please try using a VPN.")
	end
end

return loadstring(riseGithubRequest("MainScript.lua"))()
