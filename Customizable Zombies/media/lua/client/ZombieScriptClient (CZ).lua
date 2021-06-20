
--
local interval = 2048;
local PUCount = 0;
local function UpdateClient()
    local player = getPlayer();
    --interval = player:getCell():getZombieList():size() * 4;
    
    if not isClient() then --singleplayer
        if SetCustomizableZombies then 
            SetCustomizableZombies(player);
        end
        
        return;
    end
    sendClientCommand(player, CZ_Util.MOD_ID, "SetCustomizableZombies", {})
end

local function Init()
    PUCount = 0;
end

local function PlayerUpdateHandle(player)
    PUCount = PUCount + 1;
	--print(PUCount);
    if(PUCount >= interval) then
        UpdateClient();
        PUCount = 0;
    end
end

Events.OnGameStart.Add(Init);
Events.OnPlayerUpdate.Add(PlayerUpdateHandle);
--]]
