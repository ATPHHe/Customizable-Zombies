
--
local interval = 512;
local PUCount = 0;
local function UpdateClient()
	local player = getPlayer();
    --interval = player:getCell():getZombieList():size() * 4;
    
	if not isClient() then --singleplayer
		SetCustomizableZombies(player)
		return;
	end
	sendClientCommand(player, CZ_Util.MOD_ID, "SetCustomizableZombies", {})
end

local function Init()
	PUCount = 0;
end

local function PlayerUpdateHandle(player)
	PUCount = PUCount + 1;
	if(PUCount == interval) then
		UpdateClient();
		PUCount = 0;
	end
end

Events.OnGameStart.Add(Init);
Events.OnPlayerUpdate.Add(PlayerUpdateHandle);
--]]
