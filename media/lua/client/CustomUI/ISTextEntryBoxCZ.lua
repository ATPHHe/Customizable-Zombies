require "ISUI/ISUIElement"

ISTextEntryBoxCZ = ISUIElement:derive("ISTextEntryBoxCZ");


--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function ISTextEntryBoxCZ:initialise()
    ISUIElement.initialise(self);
end

function ISTextEntryBoxCZ:validate()
    local text = self:getInternalText()
    --text = text:gsub("[^%d^.]+", "")
    self:setText(text)
    
    local num = tonumber(text)
    if num == nil then num = 1 end
    if num and num < self.minValue then num = self.minValue end
    if num and num > self.maxValue then num = self.maxValue end
    
    self:setText(string.format("%f", num))
    
end

function ISTextEntryBoxCZ:onCommandEntered()
    
end

function ISTextEntryBoxCZ:onTextChange()
    --print(self:getText().."TEXTCHANGE TEXT")
    --print(self:getInternalText().."TEXTCHANGE INTERNALTEXT")
    
    --local text = self:getInternalText()
    --text = text:gsub("/^[+-]?((\d+(\.\d*)?)|(\.\d+))$/", "")
    --self:setText(text)
    
    --self:validate()
end

function ISTextEntryBoxCZ:ignoreFirstInput()
    self.javaObject:ignoreFirstInput();
end

function ISTextEntryBoxCZ:setOnlyNumbers(onlyNumbers)
    self.javaObject:setOnlyNumbers(onlyNumbers);
end
--************************************************************************--
--** ISPanel:instantiate
--**
--************************************************************************--
function ISTextEntryBoxCZ:instantiate()
    --self:initialise();
    self.javaObject = UITextBox2.new(self.font, self.x, self.y, self.width, self.height, self.title, false);
    self.javaObject:setTable(self);
    self.javaObject:setX(self.x);
    self.javaObject:setY(self.y);
    self.javaObject:setHeight(self.height);
    self.javaObject:setWidth(self.width);
    self.javaObject:setAnchorLeft(self.anchorLeft);
    self.javaObject:setAnchorRight(self.anchorRight);
    self.javaObject:setAnchorTop(self.anchorTop);
    self.javaObject:setAnchorBottom(self.anchorBottom);
    self.javaObject:setEditable(true);
    --self.javaObject:setText(self.title);

end
function ISTextEntryBoxCZ:getText()
    return self.javaObject:getText();
end

function ISTextEntryBoxCZ:setEditable(editable)
    self.javaObject:setEditable(editable);
    if editable then
        self.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    else
        self.borderColor = {r=0.4, g=0.4, b=0.4, a=0.5}
    end
end

function ISTextEntryBoxCZ:setSelectable(enable)
    self.javaObject:setSelectable(enable)
end

function ISTextEntryBoxCZ:setMultipleLine(multiple)
    self.javaObject:setMultipleLine(multiple);
end

function ISTextEntryBoxCZ:setMaxLines(max)
    self.javaObject:setMaxLines(max);
end

function ISTextEntryBoxCZ:setClearButton(hasButton)
    self.javaObject:setClearButton(hasButton);
end

function ISTextEntryBoxCZ:setText(str)
    if not str then
        str = "";
    end
    self.javaObject:SetText(str);
    self.title = str;
end

function ISTextEntryBoxCZ:onPressDown()
    self:validate()
end

function ISTextEntryBoxCZ:onPressUp()
    self:validate()
end

function ISTextEntryBoxCZ:focus()
    self:validate()
    return self.javaObject:focus();
end

function ISTextEntryBoxCZ:unfocus()
    self:validate()
    return self.javaObject:unfocus();
end

function ISTextEntryBoxCZ:getInternalText()
    return self.javaObject:getInternalText();
end

function ISTextEntryBoxCZ:setMasked(b)
    return self.javaObject:setMasked(b);
end

function ISTextEntryBoxCZ:setMaxTextLength(length)
    self.javaObject:setMaxTextLength(length);
end

function ISTextEntryBoxCZ:setForceUpperCase(forceUpperCase)
    self.javaObject:setForceUpperCase(forceUpperCase);
end

--************************************************************************--
--** ISPanel:render
--**
--************************************************************************--
function ISTextEntryBoxCZ:prerender()

    self.fade:setFadeIn(self:isMouseOver() or self.javaObject:isFocused())
    self.fade:update()

    self:drawRectStatic(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    if self.borderColor.a == 1 then
        local rgb = math.min(self.borderColor.r + 0.2 * self.fade:fraction(), 1.0)
        self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, rgb, rgb, rgb);
    else -- setValid(false)
        local r = math.min(self.borderColor.r + 0.2 * self.fade:fraction(), 1.0)
        self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, r, self.borderColor.g, self.borderColor.b)
    end

    if self:isMouseOver() and self.tooltip then
        local text = self.tooltip;
        if not self.tooltipUI then
            self.tooltipUI = ISToolTip:new()
            self.tooltipUI:setOwner(self)
            self.tooltipUI:setVisible(false)
        end
        if not self.tooltipUI:getIsVisible() then
            if string.contains(self.tooltip, "\n") then
                self.tooltipUI.maxLineWidth = 1000 -- don't wrap the lines
            else
                self.tooltipUI.maxLineWidth = 300
            end
            self.tooltipUI:addToUIManager()
            self.tooltipUI:setVisible(true)
            self.tooltipUI:setAlwaysOnTop(true)
        end
        self.tooltipUI.description = text
        self.tooltipUI:setX(self:getMouseX() + 23)
        self.tooltipUI:setY(self:getMouseY() + 23)
    else
        if self.tooltipUI and self.tooltipUI:getIsVisible() then
            self.tooltipUI:setVisible(false)
            self.tooltipUI:removeFromUIManager()
        end
    end
end

function ISTextEntryBoxCZ:onMouseMove(dx, dy)
    self.mouseOver = true
end

function ISTextEntryBoxCZ:onMouseMoveOutside(dx, dy)
    self.mouseOver = false
end

function ISTextEntryBoxCZ:onMouseWheel(del)
    self:setYScroll(self:getYScroll() - (del*40))
    return true;
end

function ISTextEntryBoxCZ:clear()
    self.javaObject:clearInput();
end

function ISTextEntryBoxCZ:setHasFrame(hasFrame)
    self.javaObject:setHasFrame(hasFrame)
end

function ISTextEntryBoxCZ:setFrameAlpha(alpha)
    self.javaObject:setFrameAlpha(alpha);
end

function ISTextEntryBoxCZ:getFrameAlpha()
    return self.javaObject:getFrameAlpha();
end

function ISTextEntryBoxCZ:setValid(valid)
    if valid then
        self.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    else
        self.borderColor = {r=0.7, g=0.1, b=0.1, a=0.7}
    end
end

function ISTextEntryBoxCZ:setTooltip(text)
    self.tooltip = text and text:gsub("\\n", "\n") or nil
end

--************************************************************************--
--** ISPanel:new
--**
--************************************************************************--
function ISTextEntryBoxCZ:new(title, x, y, width, height, minValue, maxValue)
    local o = {}
    --o.data = {}
    o = ISUIElement:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.x = x;
    o.y = y;
    
    o.title = title;
    o.backgroundColor = {r=0, g=0, b=0, a=0.5};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.width = width;
    o.height = height;
    o.keeplog = false;
    o.logIndex = 0;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    o.fade = UITransition.new()
    o.font = UIFont.Small
    o.currentText = title;
    
    o.isTextEntryBox = true;
    
    o.minValue = minValue
    o.maxValue = maxValue
    
    return o
end
