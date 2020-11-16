--
--*****************************************
--*** UI Configuration Options (CZ).lua ***
--*****************************************
--* Coded by: ATPHHe
--* Date Created: 02/18/2020
--*******************************
--
--============================================================

require "ISUI/ISPanel"

local VERSION = "2.4.0"

--local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
--local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
--local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)

local function okModal(_text, _centered, _width, _height, _posX, _posY, _func)
    local posX = _posX or 0;
    local posY = _posY or 0;
    local width = _width or 230;
    local height = _height or 120;
    local centered = _centered;
    local txt = _text;
	local func = _func or nil;
    local core = getCore();

    -- center the modal if necessary
    if centered then
        posX = core:getScreenWidth() * 0.5 - width;
        posY = core:getScreenHeight() * 0.5 - height;
    end

    local modal = ISModalDialog:new(posX, posY, width, height, txt, false, nil, func);
	modal.backgroundColor = {r=0, g=0, b=0, a=1};
	
	modal.render = function()
		modal:bringToTop()
	end
	
    modal:initialise();
    modal:addToUIManager();
end



local function showUpdate()
    
    local util = CZ_Util
    
    local data = util.LoadFromFile("_data", true)
    if not data or data[1] == nil then 
        data = {} end
    if data[1] == VERSION then return end
    
    local fContents = util.LoadFromFile("_ReleaseNotes.txt", true)
    
    local text = "";
    for i, v in ipairs(fContents) do
        
        local pattern = "%$[%a%p%d]+%$"
        local i1, j1 = v:find(pattern)
        while i1 do
            
            local t1 = v:sub(i1, j1)
            t1 = t1:gsub("%$", "%%$")
            local t2 = v:sub(i1 + 1, j1 - 1)
            v = v:gsub(t1, getText(t2))
            
            i1, j1 = v:find(pattern)
        end
        
        if fContents[i+1] ~= nil then
            text = text .. tostring(v) .. "\r\n"
        else
            text = text .. tostring(v)
        end
        
    end
    
    okModal(text, true, nil, nil, nil, nil, 
                function() 
                    data = {}
                    data[1] = VERSION
                    
                    local text = "";
                    for i, v in ipairs(data) do
                        if data[i+1] ~= nil then
                            text = text .. tostring(v) .. "\r\n"
                        else
                            text = text .. tostring(v)
                        end
                    end
                    
                    util.SaveToFile("_data", text, true)
                    
                    return
                end)
    
end

Events.OnMainMenuEnter.Add(showUpdate)


