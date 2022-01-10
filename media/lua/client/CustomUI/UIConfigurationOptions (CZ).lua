--
--*****************************************
--*** UI Configuration Options (CZ).lua ***
--*****************************************
--* Coded by: ATPHHe
--* Date Created: 02/07/2020
--*******************************
--
--============================================================
local settingsTitle = "CZombie"

CustomizableZombiesUI = {}
--============================================================

function CustomizableZombiesUI.init()
    if not isClient() then --singleplayer
        if InitCustomizableZombies then 
            InitCustomizableZombies(CZ_Util.configOpts);
        end
        
        return;
    end
    
    local strConfigOpts = CZ_Util.table_to_string(CZ_Util.configOpts)
    sendClientCommand(player, CZ_Util.MOD_ID, "InitCustomizableZombies", {strConfigOpts=strConfigOpts})
end


-- Overwrite old values of HPMultipliers
if CZ_Util.configOpts["Version"] ~= "2.3.0" then
    CZ_Util.configOpts["Version"] = "2.3.0"
    CZ_Util.configOpts["FakeDead"]["HPMultiplier"] = 1000
    CZ_Util.configOpts["Crawler"]["HPMultiplier"] = 1000
    CZ_Util.configOpts["Shambler"]["HPMultiplier"] = 1000
    CZ_Util.configOpts["FastShambler"]["HPMultiplier"] = 1000
    CZ_Util.configOpts["Runner"]["HPMultiplier"] = 1000
    CZ_Util.io_persistence.store(CZ_Util.ConfigFileLocation, CZ_Util.MOD_ID, CZ_Util.configOpts)
end

local function getOptions(optionName)

    local options = {}
    
    if optionName == "FakeDead" 
            or optionName == "Crawler" 
            or optionName == "Shambler" 
            or optionName == "FastShambler" 
            or optionName == "Runner" then
        for i = 1000, 0, -1 do 
            local num = i / 10.0
            table.insert(options, tostring(string.format("%.1f", num) .. " %"))
        end
    end
    if optionName == "HPMultiplier" then
        for i = 4000, 1, -1 do 
            local num = i / 10.0 / 100.0
            table.insert(options, tostring(string.format("%.3f", num) .. ""))
        end
    end
    if optionName == "Preset" then 
        table.insert(options, "No Preset Selected") 
        table.insert(options, "5% | 45% | 45% | 5%") 
        table.insert(options, "5% | 47% | 47% | 1%") 
        table.insert(options, "5% | 47.4% | 47.5% | 0.1%")
        table.insert(options, "5% | 32% | 32% | 31%") 
        table.insert(options, "5% | 5% | 5% | 85%") 
        table.insert(options, "5% | 1% | 1% | 93%") 
        table.insert(options, "25% | 25% | 25% | 25%") 
    end
    
    return options
end

local function getOptionsValues(optionName)

    local options = {}
    
    if optionName == "FakeDead" 
            or optionName == "Crawler" 
            or optionName == "Shambler" 
            or optionName == "FastShambler" 
            or optionName == "Runner" then
        for i = 1000, 0, -1 do 
            table.insert(options, i) 
        end
    end
    if optionName == "HPMultiplier" then
        for i = 4000, 1, -1 do 
            table.insert(options, i) 
        end
    end
    if optionName == "Preset" then 
        for i = 1, 8, 1 do 
            table.insert(options, i) 
        end
    end
    
    return options
end

local function getConfigIndex(optionName, value)

    local index = 1
    if optionName == "FakeDead" 
            or optionName == "Crawler" 
            or optionName == "Shambler" 
            or optionName == "FastShambler" 
            or optionName == "Runner" then
        for i = 1000, 0, -1 do 
             if value == i then return index else index = index + 1 end
        end
    end
    if optionName == "HPMultiplier" then
        index = 1
        for i = 4000, 1, -1 do 
            if value == i then return index else index = index + 1 end
        end
    end
    if optionName == "Preset" then 
        index = 1
        for i = 1, 8, 1 do 
            if value == i then return index else index = index + 1 end
        end
    end
end

local function getConfigValue(optionName, index)

    local options = getOptionsValues(optionName)
    return options[index]
    
end


--*************************
-- UI Functions
local GameOption = ISBaseObject:derive("GameOption")

-- GameOption
function GameOption:new(name, control, arg1, arg2)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.control = control
    o.arg1 = arg1
    o.arg2 = arg2
    if control.isTextEntryBox then
        control.onTextChange = function()
            o.gameOptions:onChange(self)
        end
    end
    if control.isCombobox then
        control.onChange = self.onChangeComboBox
        control.target = o
    end
    if control.isTickBox then
        control.changeOptionMethod = self.onChangeTickBox
        control.changeOptionTarget = o
    end
    if control.isSlider then
        control.targetFunc = self.onChangeVolumeControl
        control.target = o
    end
    return o
end

function GameOption:toUI()
    print('ERROR: option "'..self.name..'" missing toUI()')
end

function GameOption:apply()
    print('ERROR: option "'..self.name..'" missing apply()')
end

--[[function GameOption:onChangeTextEntryBox(box)
    self.gameOptions:onChange(self)
    if self.onChange then
        self:onChange(box)
    end
end--]]

function GameOption:onChangeComboBox(box)
    self.gameOptions:onChange(self)
    if self.onChange then
        self:onChange(box)
    end
end

function GameOption:onChangeTickBox(index, selected)
    self.gameOptions:onChange(self)
    if self.onChange then
        self:onChange(index, selected)
    end
end

function GameOption:onChangeVolumeControl(control, volume)
    self.gameOptions:onChange(self)
    if self.onChange then
        self:onChange(control, volume)
    end
end

-- MainOptions
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

function MainOptions:addTextEntryBox(x, y, w, h, name, text, minValue, maxValue)

    h = FONT_HGT_SMALL + 3 * 2

    local label = ISLabel:new(x, y + self.addY, h, name, 1, 1, 1, 1, UIFont.Small);
    label:initialise();
    self.mainPanel:addChild(label);
    local panel2 = ISTextEntryBoxCZ:new(text, x+20, y + self.addY, w, h, minValue, maxValue)
    panel2:initialise();
    
    panel2:instantiate()
    panel2:setOnlyNumbers(true)  
    
    self.mainPanel:addChild(panel2);
    self.mainPanel:insertNewLineOfButtons(panel2)
    self.addY = self.addY + h + 6;
    return panel2;
end

local oldMainOptionsCreateFunction = MainOptions.create

local changeIndex = 0
local lblCZ = nil
function MainOptions:create()
    oldMainOptionsCreateFunction(self)
    
    for _, keyTextElement in pairs(MainOptions.keyText) do 
        repeat
            -- if keyTextElement is nil or doesn't have a ISLabel, break out of the 
            -- "repeat ... until true"  loop, and continue with the "for .. do ... end" 
            -- loop
            if not keyTextElement or not keyTextElement.txt then break end
            
            local label = keyTextElement.txt -- our ISLabel item is stored in keyTextElement.txt
            -- We need to do a few things here to prep the new entries.
            -- 1) We wont have a proper translation, and the translation will be set to
            --    "UI_optionscreen_binding_Equip/Unequip Pistol", which will look funny on the 
            --    options screen, so we need to fix
            -- 2) the new translation doesn't properly adjust the x position and width, so we need to 
            --    manually adjust these
            
            ----- Coding/Programming Strings -----
            if label.name == "true" then
                label:setTranslation(getText("ContextMenu_CustomizableZombies_true"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "false" then
                label:setTranslation(getText("ContextMenu_CustomizableZombies_false"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- HP Multiplier -----
            elseif label.name == "HP Multiplier" then
                label:setTranslation(getText("ContextMenu_CustomizableZombies_HPMultiplier"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- FakeDead -----
            elseif label.name == "% chance to spawn in Fake Dead state" then
                label:setTranslation(getText("ContextMenu_CustomizableZombies_1_Title"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "The % chance that a zombie will be in a Fake Dead state." then 
                label:setTranslation(getText("ContextMenu_CustomizableZombies_1_Tooltip"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- Crawler -----
            elseif label.name == "% of Crawlers" then 
                label:setTranslation(getText("ContextMenu_CustomizableZombies_2_Title"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "The % chance that a zombie will be a Crawler." then 
                label:setTranslation(getText("ContextMenu_CustomizableZombies_2_Tooltip"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- Shambler -----
            elseif label.name == "% of Shamblers" then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_3_Title"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "The % chance that a zombie will be a Shambler." then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_3_Tooltip"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- FastShambler -----
            elseif label.name == "% of Fast Shamblers" then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_4_Title"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "The % chance that a zombie will be a Fast Shambler." then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_4_Tooltip"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- Runner -----
            elseif label.name == "% of Runners" then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_5_Title"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "The % chance that a zombie will be a Runner." then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_5_Tooltip"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- Preset -----
            elseif label.name == "Preset: " then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_6_Title"))
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "I created presets here for convenience." then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_6_Tooltip"))
                label:setX(label.x)
                label:setWidth(label.width)
            
            ----- README Message -----
            elseif label.name == "README: \r\nHit 'APPLY' to make sure the percentages balance how you want it to. \r\nThe Crawler, Shambler, Fast Shamber, and Runner percentages must combine and equal 100% total. \r\n\r\n(Fake Dead % is not affected)" then  
                label:setTranslation(getText("ContextMenu_CustomizableZombies_ReadmeMessage"))
                label:setX(label.x)
                label:setWidth(label.width)
            end
            
        until true 
    end
    
    
    
    local spacing = 10

    self:addPage(settingsTitle)
    self.addY = 0
    
    local oldGameOptionsToUI = self.gameOptions.toUI
    function self.gameOptions:toUI()
        oldGameOptionsToUI(self)
        
        CZ_Util.io_persistence.load(CZ_Util.ConfigFileLocation, CZ_Util.MOD_ID, CZ_Util.configOpts)
        for _,option in ipairs(self.options) do
            option:toUI()
        end
        self.changed = false
    end
    
    local gameOptions = self.gameOptions
    --local label
    local y = 25
    local comboWidth = 300
    local splitpoint = self:getWidth() / 3;
    
    
    ----- Message Box -----
    local message = getText("ContextMenu_CustomizableZombies_ReadmeMessage")
    
    lblCZ = ISLabel:new(self:getWidth() / 5, 2 + self.y / 2, y, message, 1, 1, 1, 1, UIFont.Small, true);
    
    lblCZ:initialise();
    self.mainPanel:addChild(lblCZ);
    
    y = y + spacing * 9
    
    
    
    ----- FakeDead -----
    local title = getText("ContextMenu_CustomizableZombies_1_Title")
    local tooltip = getText("ContextMenu_CustomizableZombies_1_Tooltip")
    local gameOptionName = 'FakeDead'
    local options = getOptions(gameOptionName)
    
    local combo1 = self:addCombo(splitpoint, y, comboWidth, 20, title, options, 1)
    combo1:setToolTipMap({defaultTooltip = tooltip});
    
    local gameOption = GameOption:new(gameOptionName, combo1)
    function gameOption.toUI(self)
        local box = self.control
        box.selected = getConfigIndex(gameOptionName, CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"])
    end
    function gameOption.apply(self)
        local box = self.control
        if box.options[box.selected] then
            print("box: " .. box.selected)
            CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
            --SaveToFile(configFileLocation)
            
            --checkIfPercentIsValidCZ(true)
        else
            print("Error: Could not set option.")
        end
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
    end
    self.gameOptions:add(gameOption)

    y = y + spacing
    
    ----- Crawler -----
    local title = getText("ContextMenu_CustomizableZombies_2_Title")
    local tooltip = getText("ContextMenu_CustomizableZombies_2_Tooltip")
    local gameOptionName = 'Crawler'
    local options = getOptions(gameOptionName)
    
    local combo1 = self:addCombo(splitpoint, y, comboWidth, 20, title, options, 1)
    combo1:setToolTipMap({defaultTooltip = tooltip});
    
    local gameOption = GameOption:new(gameOptionName, combo1)
    function gameOption.toUI(self)
        local box = self.control
        box.selected = getConfigIndex(gameOptionName, CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"])
    end
    function gameOption.apply(self)
        local box = self.control
        if box.options[box.selected] then
            print("box: " .. box.selected)
            CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
            --SaveToFile(configFileLocation)
            
            checkIfPercentIsValidCZ(true)
        else
            print("Error: Could not set option.")
        end
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
        changeIndex = 0
        
        gameOptions:get("Preset").control.selected = 1
        CZ_Util.configOpts["Preset"]["PresetNum"] = 1
    end
    self.gameOptions:add(gameOption)
    
    -- HPMultiplier --
    y = y
    local title = getText("ContextMenu_CustomizableZombies_HPMultiplier")
    local tooltip = "MIN: 0.001, MAX: 100   ".."\r\n"..getText("ContextMenu_CustomizableZombies_HPMultiplier_Tooltip")
    local gameOptionSubKey = 'HPMultiplier'
    --local options = getOptions(gameOptionSubKey)
    
    local textEntry = self:addTextEntryBox(splitpoint, y, comboWidth, 20, title, "1", 0.001, 100)
    textEntry:setTooltip(tooltip);
    
    local gameOption = GameOption:new(gameOptionName..gameOptionSubKey, textEntry)
    function gameOption.toUI(self)
        local box = self.control
        box:setText( tostring( CZ_Util.configOpts[gameOptionName][gameOptionSubKey] / 1000 ) )
        if not box:getText() or box:getText() == "" or not tonumber(box:getText()) then 
            box:setText("1") 
        end
        --print("SELECTED: " .. tostring(box.selected))
    end
    function gameOption.apply(self)
        local box = self.control
        print("box: " .. box:getText())
        
        box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
        
        checkIfPercentIsValidCZ(true)
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        
        --box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
    end
    self.gameOptions:add(gameOption)
    
    y = y + spacing
    
    --[[
    y = y
    local title = getText("ContextMenu_CustomizableZombies_HPMultiplier")
    local tooltip = getText("ContextMenu_CustomizableZombies_HPMultiplier_Tooltip")
    local gameOptionSubKey = 'HPMultiplier'
    local options = getOptions(gameOptionSubKey)
    
    local combo1 = self:addCombo(splitpoint, y, comboWidth, 20, title, options, 1)
    combo1:setToolTipMap({defaultTooltip = tooltip});
    
    local gameOption = GameOption:new(gameOptionName..gameOptionSubKey, combo1)
    function gameOption.toUI(self)
        local box = self.control
        box.selected = getConfigIndex(gameOptionSubKey, CZ_Util.configOpts[gameOptionName][gameOptionSubKey])
        if not box.selected then box.selected = 1 end
        --print("SELECTED: " .. tostring(box.selected))
    end
    function gameOption.apply(self)
        local box = self.control
        if box.options[box.selected] then
            print("box: " .. box.selected)
            CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = getConfigValue(gameOptionSubKey, box.selected)
            --SaveToFile(configFileLocation)
            
            checkIfPercentIsValidCZ(true)
        else
            print("Error: Could not set option.")
        end
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = getConfigValue(gameOptionSubKey, box.selected)
    end
    self.gameOptions:add(gameOption)
    
    y = y + spacing
    --]]
    
    ----- Shambler -----
    local title = getText("ContextMenu_CustomizableZombies_3_Title")
    local tooltip = getText("ContextMenu_CustomizableZombies_3_Tooltip")
    local gameOptionName = 'Shambler'
    local options = getOptions(gameOptionName)
    
    local combo1 = self:addCombo(splitpoint, y, comboWidth, 20, title, options, 1)
    combo1:setToolTipMap({defaultTooltip = tooltip});
    
    local gameOption = GameOption:new(gameOptionName, combo1)
    function gameOption.toUI(self)
        local box = self.control
        box.selected = getConfigIndex(gameOptionName, CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"])
    end
    function gameOption.apply(self)
        local box = self.control
        if box.options[box.selected] then
            print("box: " .. box.selected)
            CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
            --SaveToFile(configFileLocation)
            
            checkIfPercentIsValidCZ(true)
        else
            print("Error: Could not set option.")
        end
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
        changeIndex = 1
        
        gameOptions:get("Preset").control.selected = 1
        CZ_Util.configOpts["Preset"]["PresetNum"] = 1
    end
    self.gameOptions:add(gameOption)
    
    -- HPMultiplier --
    y = y
    local title = getText("ContextMenu_CustomizableZombies_HPMultiplier")
    local tooltip = "MIN: 0.001, MAX: 100   ".."\r\n"..getText("ContextMenu_CustomizableZombies_HPMultiplier_Tooltip")
    local gameOptionSubKey = 'HPMultiplier'
    --local options = getOptions(gameOptionSubKey)
    
    local textEntry = self:addTextEntryBox(splitpoint, y, comboWidth, 20, title, "1", 0.001, 100)
    textEntry:setTooltip(tooltip);
    
    local gameOption = GameOption:new(gameOptionName..gameOptionSubKey, textEntry)
    function gameOption.toUI(self)
        local box = self.control
        box:setText( tostring( CZ_Util.configOpts[gameOptionName][gameOptionSubKey] / 1000 ) )
        if not box:getText() or box:getText() == "" or not tonumber(box:getText()) then 
            box:setText("1") 
        end
        --print("SELECTED: " .. tostring(box.selected))
    end
    function gameOption.apply(self)
        local box = self.control
        print("box: " .. box:getText())
        
        box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
        
        checkIfPercentIsValidCZ(true)
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        
        --box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
    end
    self.gameOptions:add(gameOption)
    
    y = y + spacing
    
    ----- FastShambler -----
    local title = getText("ContextMenu_CustomizableZombies_4_Title")
    local tooltip = getText("ContextMenu_CustomizableZombies_4_Tooltip")
    local gameOptionName = 'FastShambler'
    local options = getOptions(gameOptionName)
    
    local combo1 = self:addCombo(splitpoint, y, comboWidth, 20, title, options, 1)
    combo1:setToolTipMap({defaultTooltip = tooltip});
    
    local gameOption = GameOption:new(gameOptionName, combo1)
    function gameOption.toUI(self)
        local box = self.control
        box.selected = getConfigIndex(gameOptionName, CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"])
    end
    function gameOption.apply(self)
        local box = self.control
        if box.options[box.selected] then
            print("box: " .. box.selected)
            CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
            --SaveToFile(configFileLocation)
            
            checkIfPercentIsValidCZ(true)
        else
            print("Error: Could not set option.")
        end
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
        changeIndex = 2
        
        gameOptions:get("Preset").control.selected = 1
        CZ_Util.configOpts["Preset"]["PresetNum"] = 1
    end
    self.gameOptions:add(gameOption)
    
    -- HPMultiplier --
    y = y
    local title = getText("ContextMenu_CustomizableZombies_HPMultiplier")
    local tooltip = "MIN: 0.001, MAX: 100   ".."\r\n"..getText("ContextMenu_CustomizableZombies_HPMultiplier_Tooltip")
    local gameOptionSubKey = 'HPMultiplier'
    --local options = getOptions(gameOptionSubKey)
    
    local textEntry = self:addTextEntryBox(splitpoint, y, comboWidth, 20, title, "1", 0.001, 100)
    textEntry:setTooltip(tooltip);
    
    local gameOption = GameOption:new(gameOptionName..gameOptionSubKey, textEntry)
    function gameOption.toUI(self)
        local box = self.control
        box:setText( tostring( CZ_Util.configOpts[gameOptionName][gameOptionSubKey] / 1000 ) )
        if not box:getText() or box:getText() == "" or not tonumber(box:getText()) then 
            box:setText("1") 
        end
        --print("SELECTED: " .. tostring(box.selected))
    end
    function gameOption.apply(self)
        local box = self.control
        print("box: " .. box:getText())
        
        box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
        
        checkIfPercentIsValidCZ(true)
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        
        --box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
    end
    self.gameOptions:add(gameOption)
    
    y = y + spacing
    
    ----- Sprinter / Runner -----
    local title = getText("ContextMenu_CustomizableZombies_5_Title")
    local tooltip = getText("ContextMenu_CustomizableZombies_5_Tooltip")
    local gameOptionName = 'Runner'
    local options = getOptions(gameOptionName)
    
    local combo1 = self:addCombo(splitpoint, y, comboWidth, 20, title, options, 1)
    combo1:setToolTipMap({defaultTooltip = tooltip});
    
    local gameOption = GameOption:new(gameOptionName, combo1)
    function gameOption.toUI(self)
        local box = self.control
        box.selected = getConfigIndex(gameOptionName, CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"])
    end
    function gameOption.apply(self)
        local box = self.control
        if box.options[box.selected] then
            print("box: " .. box.selected)
            CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
            --SaveToFile(configFileLocation)
            
            checkIfPercentIsValidCZ(true)
        else
            print("Error: Could not set option.")
        end
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        CZ_Util.configOpts[gameOptionName]["ChanceToSpawn"] = getConfigValue(gameOptionName, box.selected)
        changeIndex = 3
        
        gameOptions:get("Preset").control.selected = 1
        CZ_Util.configOpts["Preset"]["PresetNum"] = 1
    end
    self.gameOptions:add(gameOption)
    
    -- HPMultiplier --
    y = y
    local title = getText("ContextMenu_CustomizableZombies_HPMultiplier")
    local tooltip = "MIN: 0.001, MAX: 100   ".."\r\n"..getText("ContextMenu_CustomizableZombies_HPMultiplier_Tooltip")
    local gameOptionSubKey = 'HPMultiplier'
    --local options = getOptions(gameOptionSubKey)
    
    local textEntry = self:addTextEntryBox(splitpoint, y, comboWidth, 20, title, "1", 0.001, 100)
    textEntry:setTooltip(tooltip);
    
    local gameOption = GameOption:new(gameOptionName..gameOptionSubKey, textEntry)
    function gameOption.toUI(self)
        local box = self.control
        box:setText( tostring( CZ_Util.configOpts[gameOptionName][gameOptionSubKey] / 1000 ) )
        if not box:getText() or box:getText() == "" or not tonumber(box:getText()) then 
            box:setText("1") 
        end
        --print("SELECTED: " .. tostring(box.selected))
    end
    function gameOption.apply(self)
        local box = self.control
        print("box: " .. box:getText())
        
        box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
        
        checkIfPercentIsValidCZ(true)
    end
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        
        --box:validate()
        CZ_Util.configOpts[gameOptionName][gameOptionSubKey] = tonumber(box:getText()) * 1000
    end
    self.gameOptions:add(gameOption)
    
    y = y + spacing
        
    ----- Preset -----
    local title = getText("ContextMenu_CustomizableZombies_6_Title")
    local tooltip = getText("ContextMenu_CustomizableZombies_6_Tooltip")
    local gameOptionName = 'Preset'
    local options = getOptions(gameOptionName)
    
    local combo1 = self:addCombo(splitpoint, y, comboWidth, 20, title, options, 1)
    combo1:setToolTipMap({defaultTooltip = tooltip});
    
    local gameOption = GameOption:new(gameOptionName, combo1)
    function gameOption.toUI(self)
        local box = self.control
        box.selected = getConfigIndex(gameOptionName, CZ_Util.configOpts[gameOptionName]["PresetNum"])
    end
    function gameOption.apply(self)
        local box = self.control
        if box.options[box.selected] then
            print("box: " .. box.selected)
            CZ_Util.configOpts[gameOptionName]["PresetNum"] = getConfigValue(gameOptionName, box.selected)
            --SaveToFile(configFileLocation)
            
            checkIfPercentIsValidCZ(true)
        else
            print("Error: Could not set option.")
        end
    end
    
    function gameOption:onChange(box)
        print("option changed to ".. tostring(box.selected))
        CZ_Util.configOpts[gameOptionName]["PresetNum"] = getConfigValue(gameOptionName, box.selected)
        if CZ_Util.configOpts[gameOptionName]["PresetNum"] == 1 then 
            -- Do Nothing.
        elseif CZ_Util.configOpts[gameOptionName]["PresetNum"] == 2 then 
            CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = 450
            CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = 450
            CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = 50
        elseif CZ_Util.configOpts[gameOptionName]["PresetNum"] == 3 then 
            CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = 470
            CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = 470
            CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = 10
        elseif CZ_Util.configOpts[gameOptionName]["PresetNum"] == 4 then 
            CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = 474
            CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = 475
            CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = 1
        elseif CZ_Util.configOpts[gameOptionName]["PresetNum"] == 5 then 
            CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = 320
            CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = 320
            CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = 310
        elseif CZ_Util.configOpts[gameOptionName]["PresetNum"] == 6 then 
            CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = 850
        elseif CZ_Util.configOpts[gameOptionName]["PresetNum"] == 7 then 
            CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = 50
            CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = 10
            CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = 10
            CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = 930
        elseif CZ_Util.configOpts[gameOptionName]["PresetNum"] == 8 then 
            CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = 250
            CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = 250
            CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = 250
            CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = 250
        end
        
        gameOptions:get("Crawler").control.selected = getConfigIndex("Crawler", CZ_Util.configOpts["Crawler"]["ChanceToSpawn"])
        gameOptions:get("Shambler").control.selected = getConfigIndex("Shambler", CZ_Util.configOpts["Shambler"]["ChanceToSpawn"])
        gameOptions:get("FastShambler").control.selected = getConfigIndex("FastShambler", CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"])
        gameOptions:get("Runner").control.selected = getConfigIndex("Runner", CZ_Util.configOpts["Runner"]["ChanceToSpawn"])
        
        checkIfPercentIsValidCZ(false)
    end
    self.gameOptions:add(gameOption)

    y = y + spacing
    
    
    
    self.addY = self.addY + MainOptions.translatorPane:getHeight() + 22
    self.mainPanel:setScrollHeight(y + self.addY + 20)
    
end

function getTotalPercentageCZ()
    return CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] + CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] + CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] + CZ_Util.configOpts["Runner"]["ChanceToSpawn"]
end

function checkIfPercentIsValidCZ(commitToSave)
    local numberCZ = getTotalPercentageCZ()
    
    local useRandom = false
    
    while(numberCZ > 1000 or numberCZ < 1000) do
        local rand = ZombRand(4)
        --useRandom = toggleRandCZ(useRandom)
        
        if numberCZ > 1000 then
            if numberCZ > 1000 and (rand == 2 or not useRandom) and changeIndex ~= 2 
                    and CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] > 0 then 
                CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] - 1
                numberCZ = getTotalPercentageCZ()
            elseif numberCZ > 1000 and (rand == 1 or not useRandom) and changeIndex ~= 1 
                    and CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] > 0 then 
                CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] - 1
                numberCZ = getTotalPercentageCZ()
            elseif numberCZ > 1000 and (rand == 3 or not useRandom) and changeIndex ~= 3 
                    and CZ_Util.configOpts["Runner"]["ChanceToSpawn"] > 0 then 
                CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = CZ_Util.configOpts["Runner"]["ChanceToSpawn"] - 1
                numberCZ = getTotalPercentageCZ()
            elseif numberCZ > 1000 and (rand == 0 or not useRandom) and changeIndex ~= 0 
                    and CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] > 0 then 
                CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] - 1
                numberCZ = getTotalPercentageCZ()
            end
        
        elseif numberCZ < 1000 then
            if numberCZ < 1000 and (rand == 2 or not useRandom) and changeIndex ~= 2 
                    and CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] < 1000 then 
                CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] + 1
                numberCZ = getTotalPercentageCZ()
            elseif numberCZ < 1000 and (rand == 1 or not useRandom) and changeIndex ~= 1 
                    and CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] < 1000 then 
                CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] + 1
                numberCZ = getTotalPercentageCZ()
            elseif numberCZ < 1000 and (rand == 3 or not useRandom) and changeIndex ~= 3 
                    and CZ_Util.configOpts["Runner"]["ChanceToSpawn"] < 1000 then 
                CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = CZ_Util.configOpts["Runner"]["ChanceToSpawn"] + 1
                numberCZ = getTotalPercentageCZ()
            elseif numberCZ < 1000 and (rand == 0 or not useRandom) and changeIndex ~= 0 
                    and CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] < 1000 then 
                CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] + 1
                numberCZ = getTotalPercentageCZ()
            end
        end
        
    end
    
    if commitToSave then 
        CZ_Util.io_persistence.store(CZ_Util.ConfigFileLocation, CZ_Util.MOD_ID, CZ_Util.configOpts)
        CustomizableZombiesUI.init()
    end
end

function toggleRandCZ(boolToggle)
    if boolToggle then
        boolToggle = false
    else 
        boolToggle = true
    end
    return boolToggle
end

