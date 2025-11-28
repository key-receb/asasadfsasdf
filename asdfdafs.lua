local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local CLOUDFLARE_API_URL = "https://recebgames.pazarimucuzluk.workers.dev/validate"

-- Offline Keys (API d��se bile �al���r) - Emergency backup
local OFFLINE_KEYS = {
	["ozkeyload"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["layla"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["opidielsex60"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["don684"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["luv34x34"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["getpeglol"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["bestmod"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["aiwprton"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["shampoo"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["thecrow"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["savy"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	},
	["Airpodking"] = {
		valid = true,
		message = "Offline key verified! Access granted.",
		benefits = "Premium access with offline key"
	}
}

-- Create RemoteEvents
local function createRemoteEvent(name)
	local remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Name = name
	remoteEvent.Parent = ReplicatedStorage
	return remoteEvent
end

local function createRemoteFunction(name)
	local remoteFunction = Instance.new("RemoteFunction")
	remoteFunction.Name = name
	remoteFunction.Parent = ReplicatedStorage
	return remoteFunction
end

-- Create the RemoteEvents
local validateKeyEvent = createRemoteEvent("ValidateKey")
local showKeyGUIEvent = createRemoteEvent("ShowKeyGUI")
local checkKeyStatusFunction = createRemoteFunction("CheckKeyStatus")

-- Function to validate key with Cloudflare API
local function ValidateKeyWithAPI(key, player)
	local success, result = pcall(function()
		local response = HttpService:RequestAsync({
			Url = CLOUDFLARE_API_URL,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = HttpService:JSONEncode({
				key = key,
				userId = player.UserId,
				username = player.Name
			})
		})

		if response.Success then
			local data = HttpService:JSONDecode(response.Body)
			return data.valid == true, data.message or "Key validation result"
		else
			return false, "API request failed"
		end
	end)

	if not success then
		print("Error validating key with API:", result)
		return false, "Error validating key"
	end

	return result
end


-- Function to give player benefits
local function GivePlayerBenefits(player)
	print("Giving benefits to player:", player.Name)
	-- Add your benefits here
	-- Example: Give coins, items, etc.
end

-- Main key validation function
local function ValidateKey(player, key)
	print("Validating key for player:", player.Name, "Key:", key)

	-- First check offline keys (API d��se bile �al���r)
	if OFFLINE_KEYS[key] then
		print("Offline key found:", key, "for player:", player.Name)
		validateKeyEvent:FireClient(player, true, OFFLINE_KEYS[key].message)
		return
	end

	-- If not offline key, validate with Cloudflare API
	local isValid, apiMessage = ValidateKeyWithAPI(key, player)
	if isValid then
		print("API key is valid, giving benefits to player:", player.Name)
		validateKeyEvent:FireClient(player, true, "Key verified! Access granted.")
	else
		-- Don't send error, just ignore invalid keys
		print("Invalid key:", key, "for player:", player.Name)
	end
end

-- Function to show key GUI
local function ShowKeyGUI(player)
	print("Showing key GUI for player:", player.Name)
end

-- Function to check key status
local function CheckKeyStatus(player)
	print("Checking key status for player:", player.Name)

	-- Check if player has any valid keys
	for key, keyData in pairs(activeKeys) do
		if keyData.player == player and not keyData.used and not IsKeyExpired(key) then
			return {
				hasValidKey = true,
				message = "You have a valid key",
				key = key,
				expirationTime = keyData.expirationTime
			}
		end
	end

	return {
		hasValidKey = false,
		message = "No valid keys found"
	}
end

-- Connect RemoteEvents
validateKeyEvent.OnServerEvent:Connect(ValidateKey)
showKeyGUIEvent.OnServerEvent:Connect(ShowKeyGUI)
checkKeyStatusFunction.OnServerInvoke = CheckKeyStatus

-- Player added event
local function OnPlayerAdded(player)
	print("Player joined:", player.Name)
end

-- Connect player events
Players.PlayerAdded:Connect(OnPlayerAdded)

-- Handle players already in game
for _, player in pairs(Players:GetPlayers()) do
	OnPlayerAdded(player)
end


print("Key System Server Script loaded successfully!")
print("API Key System: Active")
print("Offline Backup: RecebGames key available")