--
--*********************
--*** Zombie Script ***
--*********************
--* Coded by: ATPHHe
--* Date Created: 02/07/2020
--*******************************
--
--============================================================

--*********************************************
-- Other Useful Functions


--**********************************************
-- Vanilla Functions


--*************************************
-- Custom Functions
local configOpts = {}
local gameVersion = tonumber(CZ_Util.GameVersionNumber);
local number1 = 0
local number2 = 0
local number3 = 0

local fakeDeadChance = 0
local crawlerChance = 0

local allowCustomize = true

local minHealthFakeDead, maxHealthFakeDead = 1, 1
local minHealthCrawler, maxHealthCrawler = 1, 1
local minHealthShambler, maxHealthShambler = 1, 1
local minHealthFastShambler, maxHealthFastShambler = 1, 1
local minHealthSprinter, maxHealthSprinter = 1, 1

local function initCZ()
    configOpts = CZ_Util.io_persistence.load(CZ_Util.ConfigFileLocation, CZ_Util.MOD_ID);
    gameVersion = tonumber(CZ_Util.GameVersionNumber);
    
    number1 = configOpts["Crawler"]["ChanceToSpawn"] + configOpts["Shambler"]["ChanceToSpawn"]
    number2 = configOpts["Crawler"]["ChanceToSpawn"] + configOpts["Shambler"]["ChanceToSpawn"] + configOpts["FastShambler"]["ChanceToSpawn"]
    number3 = configOpts["Crawler"]["ChanceToSpawn"] + configOpts["Shambler"]["ChanceToSpawn"] + configOpts["FastShambler"]["ChanceToSpawn"] + configOpts["Runner"]["ChanceToSpawn"]
    
    fakeDeadChance = configOpts["FakeDead"]["ChanceToSpawn"]
    crawlerChance = configOpts["Crawler"]["ChanceToSpawn"]
    
    --**** HEALTH STUFF ****
    --local curHealth = zombie:getHealth()
    local minHealth, maxHealth = 1, 1
    local zToughness = SandboxVars.ZombieLore.Toughness
    if (zToughness == 1) then
        --health = 1.5 + ZombRandFloat(0.0, 0.3)
        minHealth = 3.5
        maxHealth = minHealth + 0.3
        
        minHealthFakeDead = 0.5
        maxHealthFakeDead = 0.8
        minHealthCrawler = minHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        maxHealthCrawler = maxHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        minHealthShambler = minHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        maxHealthShambler = maxHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        minHealthFastShambler = minHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        maxHealthFastShambler = maxHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        minHealthSprinter = minHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
        maxHealthSprinter = maxHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
    elseif (zToughness == 2) then
        --health = 1.5 + ZombRandFloat(0.0, 0.3)
        minHealth = 1.5
        maxHealth = minHealth + 0.3
        
        minHealthFakeDead = 0.5
        maxHealthFakeDead = 0.8
        minHealthCrawler = minHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        maxHealthCrawler = maxHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        minHealthShambler = minHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        maxHealthShambler = maxHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        minHealthFastShambler = minHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        maxHealthFastShambler = maxHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        minHealthSprinter = minHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
        maxHealthSprinter = maxHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
    elseif (zToughness == 3) then
        --health = 0.5 + ZombRandFloat(0.0, 0.3)
        minHealth = 0.5
        maxHealth = minHealth + 0.3
        
        minHealthFakeDead = 0.5
        maxHealthFakeDead = 0.8
        minHealthCrawler = minHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        maxHealthCrawler = maxHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        minHealthShambler = minHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        maxHealthShambler = maxHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        minHealthFastShambler = minHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        maxHealthFastShambler = maxHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        minHealthSprinter = minHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
        maxHealthSprinter = maxHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
    elseif (zToughness == 4) then
        --health = ZombRandFloat(0.5, 3.5) + ZombRandFloat(0.0, 0.3)
        minHealth = 0.5
        maxHealth = 3.8
        
        minHealthFakeDead = 0.5
        maxHealthFakeDead = 0.8
        minHealthCrawler = minHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        maxHealthCrawler = maxHealth * configOpts["Crawler"]["HPMultiplier"] / 10 / 100
        minHealthShambler = minHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        maxHealthShambler = maxHealth * configOpts["Shambler"]["HPMultiplier"] / 10 / 100
        minHealthFastShambler = minHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        maxHealthFastShambler = maxHealth * configOpts["FastShambler"]["HPMultiplier"] / 10 / 100
        minHealthSprinter = minHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
        maxHealthSprinter = maxHealth * configOpts["Runner"]["HPMultiplier"] / 10 / 100
    end
end

-- Sets a zombie's attributes.
function setZombieAttributesCustomizableZombies(zombie)
    
    --zombie:setAttackDelayMax(0.01)
	local zModData = zombie:getModData();
    --local dieCount = zombie:getDieCount()
    
    if not allowCustomize then
        return
    end
    
	if zModData.finishedCustomizableZombies ~= "done" then
        --print(dieCount)
        --zModData.ZombieTypeCZ = "Normal"
        zModData.ZombieTypeCZ = ""
        
        -- 1000 = 100.0% (Floats have Floating point errors and I do not want to use them.)
        if number3 < 0 then return end
        
        -- RNG variables
        local rand1 = ZombRand(number3) + 1
        local rand2 = ZombRand(number3) + 1
        
        -- Fake Dead
        if 0 < rand1 and rand1 <= fakeDeadChance then 
			zModData.IsFakeDead = "Fake Dead"
        end
        
        -- Crawler
		if 0 < rand2 and rand2 <= crawlerChance then 
			zModData.ZombieTypeCZ = "Crawler"
		end
		
        -- Shambler
		if crawlerChance < rand2 and rand2 <= number1 then 
			zModData.ZombieTypeCZ = "Shambler"
		end
        
        -- Fast Shambler
		if number1 < rand2 and rand2 <= number2 then 
			zModData.ZombieTypeCZ = "Fast Shambler"
		end
        
        -- Runner
		if number2 < rand2 and rand2 <= number3 then 
			zModData.ZombieTypeCZ = "Runner"
		end
        
        --print(zModData.finishedCustomizableZombies)
        --print(zModData.ZombieTypeCZ)
        --print(zModData.IsFakeDead)
        --print(rand2)
        --print(configOpts["Crawler"]["ChanceToSpawn"])
        --print(number1)
        --print(number2)
        --print(number3)
        
        --print(gameVersion)
        --zombie:setSpeedMod(1.1)
        
        --if dieCount <= 0 then zombie:setDieCount(1) end
        --for k, v in pairs(zModData) do
        --    print (tostring(k) .. " " .. tostring(v))
        --end
        
        zModData.finishedCustomizableZombies = "done"
        --zModData.counterCZ = 0
        ------------------------------
        -- Apply Stats
        ------------------------------
        
        -- Fake Dead
        if zModData.IsFakeDead == "Fake Dead" then 
            zombie:setFakeDead(true)
            if gameVersion >= 41 then zombie:setMoving(false) end
        else 
            zombie:setFakeDead(false)
        end
        
        
        --local curHealth = zombie:getHealth()
        local health = 1.5 + ZombRandFloat(0.0, 0.3)
        local zToughness = SandboxVars.ZombieLore.Toughness
        if not zombie:isFakeDead() then
            if (zToughness == 1) then
                health = 3.5 + ZombRandFloat(0.0, 0.3)
            elseif (zToughness == 2) then
                health = 1.5 + ZombRandFloat(0.0, 0.3)
            elseif (zToughness == 3) then
                health = 0.5 + ZombRandFloat(0.0, 0.3)
            elseif (zToughness == 4) then
                health = ZombRandFloat(0.5, 3.5) + ZombRandFloat(0.0, 0.3)
            end
        else
            health = 0.5 + ZombRandFloat(0.0, 0.3)
        end
        --print(zToughness)
        
        
        -- Crawler
        if zModData.ZombieTypeCZ == "Crawler" then 
            --zombie:setSpeedMod(1.0)
            if zombie:getSpeedMod() >= 0.55 then
                zombie:toggleCrawling()
            end
            zombie:setHealth(health * (configOpts["Crawler"]["HPMultiplier"] / 10 / 100))
        end
        
        -- Shambler
        if zModData.ZombieTypeCZ == "Shambler" then 
            --zombie:setSpeedMod(0.55)
            if zombie:getSpeedMod() < 0.55 then
                zombie:toggleCrawling()
            end
            zombie:changeSpeed(3)
            zombie:setHealth(health * (configOpts["Shambler"]["HPMultiplier"] / 10 / 100))
        end
        
        -- Fast Shambler
        if zModData.ZombieTypeCZ == "Fast Shambler" then 
            --zombie:setSpeedMod(0.85)
            if zombie:getSpeedMod() < 0.55 then
                zombie:toggleCrawling()
            end
            zombie:changeSpeed(2)
            zombie:setHealth(health * (configOpts["FastShambler"]["HPMultiplier"] / 10 / 100))
        end
        
        -- Runner
        if zModData.ZombieTypeCZ == "Runner" then 
            if zombie:getSpeedMod() < 0.55 then
                zombie:toggleCrawling()
            end
            zombie:changeSpeed(1)
            zombie:setHealth(health * (configOpts["Runner"]["HPMultiplier"] / 10 / 100))
        end
        
        -- Apply stats (Works only for Build 41+; Causes speed bugs with any build under 41).
        if gameVersion >= 41 then zombie:DoZombieStats() end
        
        --zombie:transmitModData()
        
        return
    end
    
    --[[
    ------------------------------
    -- Apply Stats Again
    ------------------------------
    
    --if ZombRand(2000) == 0 or zModData.counterCZ <= 1 then
    if zModData.counterCZ <= 1 then
    
        --print(zModData.counterCZ)
        zModData.counterCZ = zModData.counterCZ + 1
        
        -- Fake Dead
        if zModData.IsFakeDead == "Fake Dead" then 
            zombie:setFakeDead(true)
            if gameVersion >= 41 then 
                zombie:setMoving(false) 
                zombie:DoZombieStats() 
            end
        elseif zombie:isFakeDead() then
            zombie:setFakeDead(false)
            if gameVersion >= 41 then zombie:DoZombieStats() end
        end
        
        -- Crawler
        if zModData.ZombieTypeCZ == "Crawler" then 
            --zombie:setSpeedMod(1.0)
            if zombie:getSpeedMod() >= 0.55 then
                zombie:toggleCrawling()
                if gameVersion >= 41 then zombie:DoZombieStats() end
            end
            return
        end
        
        -- Shambler
        if zModData.ZombieTypeCZ == "Shambler" then 
            --zombie:setSpeedMod(0.55)
            zombie:changeSpeed(3)
            if gameVersion >= 41 then zombie:DoZombieStats() end
            return
        end
        
        -- Fast Shambler
        if zModData.ZombieTypeCZ == "Fast Shambler" then 
            --zombie:setSpeedMod(0.85)
            zombie:changeSpeed(2)
            if gameVersion >= 41 then zombie:DoZombieStats() end
            return
        end
        
        -- Runner
        if zModData.ZombieTypeCZ == "Runner" then 
            zombie:changeSpeed(1)
            if gameVersion >= 41 then zombie:DoZombieStats() end
            return
        end
    end]]
    
end

-- Checks the zombie and update them if they are not the correct type.
function checkZombieAttributesCustomizableZombies(zombie)
    --print(tostring(zombie:getObjectName()) .. " | " .. tostring(zombie:getName()) )
    
    -----------------------------------------------
    if not allowCustomize then
        return
    end
    
    local square = zombie:getSquare()
    for i=0, getNumActivePlayers() do
        if square:isCanSee(i) then 
            --print("CAN SEE PLAYER " .. i .. ".") 
            return 
        end
    end
    
    local zModData = zombie:getModData();
    
    ------------------------------
    -- Apply Stats Again
    ------------------------------
    
    --if ZombRand(2000) == 0 or zModData.counterCZ <= 1 then
    --zModData.counterCZ = (zModData.counterCZ or 0) + 1
    
    --if zModData.counterCZ >= 1024 then
        
        --zModData.counterCZ = 0
        
        local speedType, bCrawling
        for i=0, getNumClassFields(zombie)-1 do
            local field = getClassField(zombie, i)
            --print(tostring(field))
            if tostring(field) == "public int zombie.characters.IsoZombie.speedType" then
                speedType = field; 
            end
            if tostring(field) == "public boolean zombie.characters.IsoZombie.bCrawling" then
                bCrawling = field; 
            end
        end
        local speedTypeVal = getClassFieldVal(zombie, speedType);
        local bCrawlingVal = getClassFieldVal(zombie, bCrawling);
        local isFakeDead = zombie:isFakeDead();
        
        --print(speedTypeVal)
        --print(bCrawlingVal)
        
        --[[
        -- Crawler
        if zModData.ZombieTypeCZ == "Crawler" then 
            if zombie:getHealth() > maxHealthCrawler then
                --local curHealth = zombie:getHealth()
                local health = 1.5 + ZombRandFloat(0.0, 0.3)
                local zToughness = SandboxVars.ZombieLore.Toughness
                if not zombie:isFakeDead() then
                    if (zToughness == 1) then
                        health = 3.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 2) then
                        health = 1.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 3) then
                        health = 0.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 4) then
                        health = ZombRandFloat(0.5, 3.5) + ZombRandFloat(0.0, 0.3)
                    end
                else
                    health = 0.5 + ZombRandFloat(0.0, 0.3)
                end
                --print(zToughness)
                zombie:setHealth(health * (configOpts["Crawler"]["HPMultiplier"] / 10 / 100))
            end
        
        
        -- Shambler
        elseif zModData.ZombieTypeCZ == "Shambler" then 
            if zombie:getHealth() > maxHealthShambler then
                --local curHealth = zombie:getHealth()
                local health = 1.5 + ZombRandFloat(0.0, 0.3)
                local zToughness = SandboxVars.ZombieLore.Toughness
                if not zombie:isFakeDead() then
                    if (zToughness == 1) then
                        health = 3.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 2) then
                        health = 1.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 3) then
                        health = 0.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 4) then
                        health = ZombRandFloat(0.5, 3.5) + ZombRandFloat(0.0, 0.3)
                    end
                else
                    health = 0.5 + ZombRandFloat(0.0, 0.3)
                end
                --print(zToughness)
                zombie:setHealth(health * (configOpts["Shambler"]["HPMultiplier"] / 10 / 100))
            end
        
        
        -- Fast Shambler
        elseif zModData.ZombieTypeCZ == "Fast Shambler" then 
            if zombie:getHealth() > maxHealthFastShambler then
                --local curHealth = zombie:getHealth()
                local health = 1.5 + ZombRandFloat(0.0, 0.3)
                local zToughness = SandboxVars.ZombieLore.Toughness
                if not zombie:isFakeDead() then
                    if (zToughness == 1) then
                        health = 3.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 2) then
                        health = 1.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 3) then
                        health = 0.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 4) then
                        health = ZombRandFloat(0.5, 3.5) + ZombRandFloat(0.0, 0.3)
                    end
                else
                    health = 0.5 + ZombRandFloat(0.0, 0.3)
                end
                --print(zToughness)
                zombie:setHealth(health * (configOpts["FastShambler"]["HPMultiplier"] / 10 / 100))
            end
        
        
        -- Runner
        elseif zModData.ZombieTypeCZ == "Runner" then 
            if zombie:getHealth() > maxHealthSprinter then
                --local curHealth = zombie:getHealth()
                local health = 1.5 + ZombRandFloat(0.0, 0.3)
                local zToughness = SandboxVars.ZombieLore.Toughness
                if not zombie:isFakeDead() then
                    if (zToughness == 1) then
                        health = 3.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 2) then
                        health = 1.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 3) then
                        health = 0.5 + ZombRandFloat(0.0, 0.3)
                    elseif (zToughness == 4) then
                        health = ZombRandFloat(0.5, 3.5) + ZombRandFloat(0.0, 0.3)
                    end
                else
                    health = 0.5 + ZombRandFloat(0.0, 0.3)
                end
                --print(zToughness)
                zombie:setHealth(health * (configOpts["Runner"]["HPMultiplier"] / 10 / 100))
            end
        end
        --]]
        
        -- Fake Dead
        if zModData.IsFakeDead == "Fake Dead" or zModData.IsFakeDead == "Fake Dead 2" or isFakeDead then 
            --[[
            if not zombie:isFakeDead() then
                zombie:setFakeDead(true)
                if gameVersion >= 41 then 
                    zombie:setMoving(false) 
                    zombie:DoZombieStats() 
                end
            end
            --]]
            return
        --elseif zombie:isFakeDead() then
        --    zombie:setFakeDead(false)
        --    if gameVersion >= 41 then zombie:DoZombieStats() end
        end
        
        --if zModData.IsFakeDead == "Fake Dead 2" then
        --    return
        --end
        
        if bCrawlingVal then return end;
        
        -- Crawler
        if zModData.ZombieTypeCZ == "Crawler" then 
            --zombie:setSpeedMod(1.0)
            if zombie:getSpeedMod() >= 0.55 then
                zombie:toggleCrawling()
                if gameVersion >= 41 then zombie:DoZombieStats() end
            end
            return
        --end
        
        -- Shambler
        elseif zModData.ZombieTypeCZ == "Shambler" and speedTypeVal ~= 3 then 
            --zombie:setSpeedMod(0.55)
            zombie:changeSpeed(3)
            if gameVersion >= 41 then zombie:DoZombieStats() end
            return
        --end
        
        -- Fast Shambler
        elseif zModData.ZombieTypeCZ == "Fast Shambler" and speedTypeVal ~= 2 then 
            --zombie:setSpeedMod(0.85)
            zombie:changeSpeed(2)
            if gameVersion >= 41 then zombie:DoZombieStats() end
            return
        --end
        
        -- Runner
        elseif zModData.ZombieTypeCZ == "Runner" and speedTypeVal ~= 1 then 
            zombie:changeSpeed(1)
            if gameVersion >= 41 then zombie:DoZombieStats() end
            return
        end
    --end
    
    return
end

-- Build 41 only
local function fakeDeadFunctions(zombie)
    
    local zModData = zombie:getModData();
    
    -- Make zombie get up and walk again from FakeDead state.
    if zModData.IsFakeDead == "Fake Dead" and zModData.ZombieTypeCZ ~= "Crawler" and zombie:isMoving() then
        
        --print("WORKING")
        local bCrawling
        for i=0, getNumClassFields(zombie)-1 do
            local field = getClassField(zombie, i)
            --print(tostring(field))
            if tostring(field) == "public boolean zombie.characters.IsoZombie.bCrawling" then
                bCrawling = field; 
            end
        end
        local bCrawlingVal = getClassFieldVal(zombie, bCrawling);
        
        --zModData.IsFakeDead = false
        --zombie:setFakeDead(false)
        zModData.IsFakeDead = "Fake Dead 2"
        --zombie:setFakeDead(false)
        
        if zModData.ZombieTypeCZ ~= "Crawler" and bCrawlingVal then
            zombie:toggleCrawling()
        end
        zombie:DoZombieStats()
    end
    
    return
end

-- Check sandbox options and only apply zombie lore when nessecary
--local sandboxTick = 0
local function sandboxChecker()
    --sandboxTick = sandboxTick + 1
    
    --if sandboxTick >= 128 then
        --sandboxTick = 0
        
        --print("AO: "..SandboxVars.ZombieLore.ActiveOnly) -- 1=Both, 2=Night, 3=Day
        if SandboxVars.ZombieLore.ActiveOnly == 1 then
            
        elseif SandboxVars.ZombieLore.ActiveOnly == 2 then
            local hour = getGameTime():getTimeOfDay()
            if 9 <= hour and hour <= 20 then 
                allowCustomize = false 
            else
                allowCustomize = true 
            end
            
        elseif SandboxVars.ZombieLore.ActiveOnly == 3 then
            local hour = getGameTime():getTimeOfDay()
            if hour >= 20 or hour <= 9 then 
                allowCustomize = false 
            else
                allowCustomize = true 
            end
            
        end
    --end
    
end

--[[function monthsToHours(months)
    local hours = tonumber(months) * 730.485
    return hours
end]]

--*************************
-- Events

Events.OnZombieUpdate.Add(setZombieAttributesCustomizableZombies)
--Events.OnZombieUpdate.Add(checkZombieAttributesCustomizableZombies)
if gameVersion >= 41 then Events.OnZombieUpdate.Add(fakeDeadFunctions) end

Events.EveryTenMinutes.Add(sandboxChecker)

--Events.OnGameStart.Add(setSandboxOptionsCustomizableZombies)
Events.OnLoad.Add(initCZ)
Events.OnServerStarted.Add(initCZ)


-- A new game starts.
--[[Events.OnNewGame.Add(function()
    
end)

Events.OnSave.Add(function()
    
end)

Events.OnLoad.Add(function()
    
end)
--]]

--
local zlist = ArrayList.new()

local ticks1 = 0
local function OnTick()
    ticks1 = ticks1 + 1
    
    if ticks1 >= 2 then
        ticks1 = 0
        if zlist and zlist:size() > 0 then
            local zombie = zlist:get(0)
            --print(zombie)
            
            if not zombie then zlist:remove(zombie) return end
            
            checkZombieAttributesCustomizableZombies(zombie)
            --if gameVersion >= 41 then fakeDeadFunctions(zombie) end
            
            --print(zlist:size())
            zlist:remove(zombie)
        end
    end
end
Events.OnTick.Add(OnTick)

function SetCustomizableZombies(player)
    
    local tlist = player:getCell():getZombieList();
    
    if not zlist then
        zlist = ArrayList.new()
    end
    
    for i=0, tlist:size()-1 do
        local z = tlist:get(i)
        if not zlist:contains( z ) then
            zlist:add( z )
        end
    end
    
	--if not zlist then		
	--	return;
	--end
    
    --print(zlist:size())
    
    --[[
    for i=0, list:size()-1 do
        local zombie = list:get(i)
        --setZombieAttributesCustomizableZombies(zombie)
        --checkZombieAttributesCustomizableZombies(zombie)
        --if gameVersion >= 41 then fakeDeadFunctions(zombie) end
    end
    --]]
end

--[[
local function OnWeaponHitCharacter(attacker, target, weapon, damageSplit)
	print("Zombie Current Health: " .. target:getHealth())
end

Events.OnWeaponHitCharacter.Add(OnWeaponHitCharacter);
--]]

local OnClientCommand = function(module, command, player, args)
	if not isServer() or module ~= CZ_Util.MOD_ID or command ~= "SetCustomizableZombies" then
		return
	end;
	SetCustomizableZombies(player);
end
Events.OnClientCommand.Add(OnClientCommand);
--]]


