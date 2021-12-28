--
--****************************
--*** Zombie Script Client ***
--****************************
--* Coded by: ATPHHe
--* Date Created: 02/07/2020
--*******************************
--
--============================================================

local interval = 2048;
local count = 0;

local interval2 = 48;
local count2 = 0;

local sentServerConfig = false;

local function Init()
    count = 0;
    count2 = 0;
end

local function UpdateClient()
    local player = getPlayer();
    --interval = player:getCell():getZombieList():size() * 4;
    
    if CZ_Util.GameVersionNumber >= 41.60 then
        if SetCustomizableZombies then 
            SetCustomizableZombies(player);
        end
        sendClientCommand(player, CZ_Util.MOD_ID, "SetCustomizableZombies", {})
    else
        if not isClient() then --singleplayer
            if SetCustomizableZombies then 
                SetCustomizableZombies(player);
            end
            
            return;
        end
        sendClientCommand(player, CZ_Util.MOD_ID, "SetCustomizableZombies", {})
    end
end

local function PlayerUpdateHandle(player)
    count = count + 1;
    --print(PUCount);
    if(count >= interval) then
        UpdateClient();
        count = 0;
    end
end

local function PlayerUpdateGetServerConfigs(player)
    count2 = count2 + 1;
    --print(count2);
    if(count2 >= interval2) then
        if not isClient() then --singleplayer
            allowRun = true
            return;
        end
        sendClientCommand(player, CZ_Util.MOD_ID, "GetServerConfigs", {})
        count2 = 0;
    end
end

local OnServerCommand = function(module, command, args)
    --print("CZClient - OnServerCommand " .. tostring(command) .. " " .. tostring(args))
    --print(player)
    if not isClient() or module ~= CZ_Util.MOD_ID then
        return
    end;
    
    if command == "SendServerConfigs" then
        
        --print(InitCustomizableZombies)
        if InitCustomizableZombies then
            --print(args)
            --local tConfigOpts = loadstring(args.configOpts)
            --InitCustomizableZombies(tConfigOpts);
            
            InitCustomizableZombies(args.configOpts);
            
            Events.OnPlayerUpdate.Remove(PlayerUpdateGetServerConfigs);
            
            allowRun = true
            
            print("CZClient - SendServerConfigs: Success");
            print("Crawler: " .. args.configOpts["Crawler"]["ChanceToSpawn"]);
            print("Shambler: " .. args.configOpts["Shambler"]["ChanceToSpawn"]);
            print("FastShambler: " .. args.configOpts["FastShambler"]["ChanceToSpawn"]);
            print("Sprinter: " .. args.configOpts["Runner"]["ChanceToSpawn"]);
        end
    end
end

Events.OnServerCommand.Add(OnServerCommand);

Events.OnGameStart.Add(Init);
Events.OnPlayerUpdate.Add(PlayerUpdateHandle);

if CZ_Util.GameVersionNumber >= 41.60 then
    Events.OnPlayerUpdate.Add(PlayerUpdateGetServerConfigs);
end
--]]
