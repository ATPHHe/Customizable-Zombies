--
--***************************
--*** Utilities ***
--***************************
--* Coded by: ATPHHe
--* 
--* Copyrighted Code Usage:
--*     RandomLua v0.3.1 COPYRIGHT(c) 2017 linux-man; Licensed under the MIT license.
--* 
--*     TablePersistence; Licensed under the MIT license
--*         - http://the-color-black.net/blog/article/LuaTablePersistence.
--*         - https://github.com/hipe/lua-table-persistence
--*******************************
--
--============================================================
CZ_Util = {}
CZ_Util.__index = CZ_Util

CZ_Util.Author = "ATPHHe"
CZ_Util.DateCreated = "02/07/2020"
CZ_Util.DateModified = "01/10/2021"
CZ_Util.MOD_ID = "CustomizableZombies"
CZ_Util.MOD_VERSION = "2.4.4.1"

CZ_Util.GameVersion = getCore():getVersionNumber()
CZ_Util.GameVersionNumber = 0

local tempIndex, _ = string.find(CZ_Util.GameVersion, " ")
if tempIndex ~= nil then
    
    CZ_Util.GameVersionNumber = tonumber(string.sub(CZ_Util.GameVersion, 0, tempIndex))
    if CZ_Util.GameVersionNumber == nil then 
        tempIndex, _ = string.find(CZ_Util.GameVersion, ".") + 1 
        CZ_Util.GameVersionNumber = tonumber(string.sub(CZ_Util.GameVersion, 0, tempIndex))
    end
else
    CZ_Util.GameVersionNumber = tonumber(CZ_Util.GameVersion)
end
tempIndex = nil

CZ_Util.DefaultSettingsFileName = "MOD DEFAULT_SETTINGS (".. CZ_Util.MOD_ID ..").lua"
CZ_Util.ConfigFileName = "MOD Configuration_Options (".. CZ_Util.MOD_ID ..").lua"
--local configFileLocation = getMyDocumentFolder() .. getFileSeparator() .. configFileName
CZ_Util.ConfigFileLocation = CZ_Util.ConfigFileName


--============================================================
--**********************************************
-- Variables


--*********************************************
-- Other Useful Functions

--[[------------------------------------
RandomLua v0.3.1
Pure Lua Pseudo-Random Numbers Generator
Under the MIT license.
copyright(c) 2017 linux-man
--]]------------------------------------

local math_floor = math.floor

local function normalize(n) --keep numbers at (positive) 32 bits
	return n % 0x80000000
end

local function bit_and(a, b)
	local r = 0
	local m = 0
	for m = 0, 31 do
		if (a % 2 == 1) and (b % 2 == 1) then r = r + 2^m end
		if a % 2 ~= 0 then a = a - 1 end
		if b % 2 ~= 0 then b = b - 1 end
		a = a / 2 b = b / 2
	end
	return normalize(r)
end

local function bit_or(a, b)
	local r = 0
	local m = 0
	for m = 0, 31 do
		if (a % 2 == 1) or (b % 2 == 1) then r = r + 2^m end
		if a % 2 ~= 0 then a = a - 1 end
		if b % 2 ~= 0 then b = b - 1 end
		a = a / 2 b = b / 2
	end
	return normalize(r)
end

local function bit_xor(a, b)
	local r = 0
	local m = 0
	for m = 0, 31 do
		if a % 2 ~= b % 2 then r = r + 2^m end
		if a % 2 ~= 0 then a = a - 1 end
		if b % 2 ~= 0 then b = b - 1 end
		a = a / 2 b = b / 2
	end
	return normalize(r)
end

local function seed()
	--return normalize(tonumber(tostring(os.time()):reverse()))
	return normalize(os.time())
end

--Mersenne twister
CZ_Util.mersenne_twister = {}
CZ_Util.mersenne_twister.__index = mersenne_twister

function CZ_Util.mersenne_twister:randomseed(s)
	if not s then s = seed() end
	self.mt[0] = normalize(s)
	for i = 1, 623 do
		self.mt[i] = normalize(0x6c078965 * bit_xor(self.mt[i-1], math_floor(self.mt[i-1] / 0x40000000)) + i)
	end
end

function CZ_Util.mersenne_twister:random(a, b)
	local y
	if self.index == 0 then
		for i = 0, 623 do   											
			--y = bit_or(math_floor(self.mt[i] / 0x80000000) * 0x80000000, self.mt[(i + 1) % 624] % 0x80000000)
			y = self.mt[(i + 1) % 624] % 0x80000000
			self.mt[i] = bit_xor(self.mt[(i + 397) % 624], math_floor(y / 2))
			if y % 2 ~= 0 then self.mt[i] = bit_xor(self.mt[i], 0x9908b0df) end
		end
	end
	y = self.mt[self.index]
	y = bit_xor(y, math_floor(y / 0x800))
	y = bit_xor(y, bit_and(normalize(y * 0x80), 0x9d2c5680))
	y = bit_xor(y, bit_and(normalize(y * 0x8000), 0xefc60000))
	y = bit_xor(y, math_floor(y / 0x40000))
	self.index = (self.index + 1) % 624
	if not a then return y / 0x80000000
	elseif not b then
		if a == 0 then return y
		else return 1 + (y % a)
		end
	else
		return a + (y % (b - a + 1))
	end
end

function CZ_Util.twister(s)
	local temp = {}
	setmetatable(temp, CZ_Util.mersenne_twister)
	temp.mt = {}
	temp.index = 0
	temp:randomseed(s)
	return temp
end

--Linear Congruential Generator
CZ_Util.linear_congruential_generator = {}
CZ_Util.linear_congruential_generator.__index = CZ_Util.linear_congruential_generator

function CZ_Util.linear_congruential_generator:random(a, b)
	local y = (self.a * self.x + self.c) % self.m
	self.x = y
	if not a then return y / 0x10000
	elseif not b then
		if a == 0 then return y
		else return 1 + (y % a) end
	else
		return a + (y % (b - a + 1))
	end
end

function CZ_Util.linear_congruential_generator:randomseed(s)
	if not s then s = seed() end
	self.x = normalize(s)
end

function CZ_Util.lcg(s, r)
	local temp = {}
	setmetatable(temp, CZ_Util.linear_congruential_generator)
	temp.a, temp.c, temp.m = 1103515245, 12345, 0x10000  --from Ansi C
	if r then
		if r == 'nr' then temp.a, temp.c, temp.m = 1664525, 1013904223, 0x10000 --from Numerical Recipes.
		elseif r == 'mvc' then temp.a, temp.c, temp.m = 214013, 2531011, 0x10000 end--from MVC
	end
	temp:randomseed(s)
	return temp
end

-- Multiply-with-carry
CZ_Util.multiply_with_carry = {}
CZ_Util.multiply_with_carry.__index = CZ_Util.multiply_with_carry

function CZ_Util.multiply_with_carry:random(a, b)
	local m = self.m
	local t = self.a * self.x + self.c
	local y = t % m
	self.x = y
	self.c = math_floor(t / m)
	if not a then return y / 0x10000
	elseif not b then
		if a == 0 then return y
		else return 1 + (y % a) end
	else
		return a + (y % (b - a + 1))
	end
end

function CZ_Util.multiply_with_carry:randomseed(s)
	if not s then s = seed() end
	self.c = self.ic
	self.x = normalize(s)
end

function CZ_Util.mwc(s, r)
	local temp = {}
	setmetatable(temp, CZ_Util.multiply_with_carry)
	temp.a, temp.c, temp.m = 1103515245, 12345, 0x10000  --from Ansi C
	if r then
		if r == 'nr' then temp.a, temp.c, temp.m = 1664525, 1013904223, 0x10000 --from Numerical Recipes.
		elseif r == 'mvc' then temp.a, temp.c, temp.m = 214013, 2531011, 0x10000 end--from MVC
	end
	temp.ic = temp.c
	temp:randomseed(s)
	return temp
end
---------------------------------------

function CZ_Util.table_to_string(tbl)
    local s = {"return {"}
    for i=1,#tbl do
        s[#s+1] = "{"
        for j=1,#tbl[i] do
            s[#s+1] = tbl[i][j]
            s[#s+1] = ","
        end
        s[#s+1] = "},"
    end
    s[#s+1] = "}"
    s = table.concat(s)
    
    return s
end

function CZ_Util.tprint(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            CZ_Util.tprint(v, indent+1)
        else
            print(formatting .. v)
        end
    end
end

function CZ_Util.deepcompare(t1,t2,ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not CZ_Util.deepcompare(v1,v2) then return false end
    end
    for k2,v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not CZ_Util.deepcompare(v1,v2) then return false end
    end
    return true
end

function CZ_Util.compare_and_insert(t1, t2, ignore_mt)
    
    local isEqual = true
    
    if not t1 then
        return false
    end
    
    if not t2 then
        t2 = {}
        isEqual = false
    end
    
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if (v2 == nil) then 
            t2[k1] = v1
            isEqual = false
        end
        
        if type(t1[k1]) == "table" then
            isEqual = CZ_Util.compare_and_insert(t1[k1], t2[k1], ignore_mt)
        end
        
    end
    
    return isEqual
end

-- Splits the string apart.
--  EX: inputstr = "Hello There Friend."
--      sep = " "
--      t = {Hello, 
--          There, 
--          Friend.}
--  EX: inputstr = "Hello,There,Friend."
--      sep = ","
--      t = {Hello, 
--          There, 
--          Friend.}
--
-- Parameters:  inputstr - the string that will be split.
--              sep - the separator character that will be used to split the string
--              t - the table that will be returned.
--
function CZ_Util.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

-- Returns true, if "a" a number. Otherwise return false.
function CZ_Util.isNumber(a)
    if tonumber(a) ~= nil then
        local number = tonumber(a)
        if number then
            return true
        end
    end
    
    return false
end


--*************************
-- I/O Functions


--[[

TablePersistence is a small code snippet that allows storing and loading of lua variables containing primitive types. It is licensed under the MIT license, use it how ever is needed. A more detailed description and complete source can be downloaded on http://the-color-black.net/blog/article/LuaTablePersistence. A fork has been created on github that included lunatest unit tests: https://github.com/hipe/lua-table-persistence

Shortcomings/Limitations:
- Does not export udata
- Does not export threads
- Only exports a small subset of functions (pure lua without upvalue)

]]
local write, writeIndent, writers, refCount;
CZ_Util.io_persistence =
{
	store = function (path, modID, ...)
		local file, e = getModFileWriter(modID, path, true, false) --e = io.open(path, "w");
		if not file then
			return error(e);
		end
		local n = select("#", ...);
		-- Count references
		local objRefCount = {}; -- Stores reference that will be exported
		for i = 1, n do
			refCount(objRefCount, (select(i,...)));
		end;
		-- Export Objects with more than one ref and assign name
		-- First, create empty tables for each
		local objRefNames = {};
		local objRefIdx = 0;
		file:write("-- Persistent Data (for "..modID..")\n");
		file:write("local multiRefObjects = {\n");
		for obj, count in pairs(objRefCount) do
			if count > 1 then
				objRefIdx = objRefIdx + 1;
				objRefNames[obj] = objRefIdx;
				file:write("{};"); -- table objRefIdx
			end;
		end;
		file:write("\n} -- multiRefObjects\n");
		-- Then fill them (this requires all empty multiRefObjects to exist)
		for obj, idx in pairs(objRefNames) do
			for k, v in pairs(obj) do
				file:write("multiRefObjects["..idx.."][");
				write(file, k, 0, objRefNames);
				file:write("] = ");
				write(file, v, 0, objRefNames);
				file:write(";\n");
			end;
		end;
		-- Create the remaining objects
		for i = 1, n do
			file:write("local ".."obj"..i.." = ");
			write(file, (select(i,...)), 0, objRefNames);
			file:write("\n");
		end
		-- Return them
		if n > 0 then
			file:write("return obj1");
			for i = 2, n do
				file:write(" ,obj"..i);
			end;
			file:write("\n");
		else
			file:write("return\n");
		end;
		if type(path) == "string" then
			file:close();
		end;
	end;

	load = function (path, modID)
		local f, e;
		if type(path) == "string" then
            --f, e = loadfile(path);
			f, e = getModFileReader(modID, path, true);
            if f == nil then f = getFileReader(sourceFile, true) end;
            
            local contents = "";
            local scanLine = f:readLine();
            while scanLine do
                
                contents = contents.. scanLine .."\r\n";
                
                scanLine = f:readLine();
                if not scanLine then break end
            end
            
            f:close();
            
            f = contents;
		else
			f, e = path:read('*a');
		end
		if f then
            local func = loadstring(f);
            if func then
                return func();
            else
                return nil;
            end
		else
			return nil, e;
		end;
	end;
}

-- Private methods

-- write thing (dispatcher)
write = function (file, item, level, objRefNames)
	writers[type(item)](file, item, level, objRefNames);
end;

-- write indent
writeIndent = function (file, level)
	for i = 1, level do
		file:write("\t");
	end;
end;

-- recursively count references
refCount = function (objRefCount, item)
	-- only count reference types (tables)
	if type(item) == "table" then
		-- Increase ref count
		if objRefCount[item] then
			objRefCount[item] = objRefCount[item] + 1;
		else
			objRefCount[item] = 1;
			-- If first encounter, traverse
			for k, v in pairs(item) do
				refCount(objRefCount, k);
				refCount(objRefCount, v);
			end;
		end;
	end;
end;

-- Format items for the purpose of restoring
writers = {
	["nil"] = function (file, item)
			file:write("nil");
		end;
	["number"] = function (file, item)
			file:write(tostring(item));
		end;
	["string"] = function (file, item)
			file:write(string.format("%q", item));
		end;
	["boolean"] = function (file, item)
			if item then
				file:write("true");
			else
				file:write("false");
			end
		end;
	["table"] = function (file, item, level, objRefNames)
			local refIdx = objRefNames[item];
			if refIdx then
				-- Table with multiple references
				file:write("multiRefObjects["..refIdx.."]");
			else
				-- Single use table
				file:write("{\r\n");
				for k, v in pairs(item) do
					writeIndent(file, level+1);
					file:write("[");
					write(file, k, level+1, objRefNames);
					file:write("] = ");
					write(file, v, level+1, objRefNames);
					file:write(";\r\n");
				end
				writeIndent(file, level);
				file:write("}");
			end;
		end;
	["function"] = function (file, item)
			-- Does only work for "normal" functions, not those
			-- with upvalues or c functions
			local dInfo = debug.getinfo(item, "uS");
			if dInfo.nups > 0 then
				file:write("nil --[[functions with upvalue not supported]]");
			elseif dInfo.what ~= "Lua" then
				file:write("nil --[[non-lua function not supported]]");
			else
				local r, s = pcall(string.dump,item);
				if r then
					file:write(string.format("loadstring(%q)", s));
				else
					file:write("nil --[[function could not be dumped]]");
				end
			end
		end;
	["thread"] = function (file, item)
			file:write("nil --[[thread]]\r\n");
		end;
	["userdata"] = function (file, item)
			file:write("nil --[[userdata]]\r\n");
		end;
}

-- Testing Persistence
--io_persistence.store("storage.lua", MOD_ID, configOpts)
--t_restored = io_persistence.load("storage.lua", MOD_ID);
--io_persistence.store("storage2.lua", MOD_ID, t_restored)



-- Save to a destination file.
-- Returns true if successful, otherwise return false if an error occured.
function CZ_Util.SaveToFile(destinationFile, text, createIfNull)
    local fileWriter = getModFileWriter(CZ_Util.MOD_ID, destinationFile, createIfNull, false)
    --if fileWriter == nil then fileWriter = getFileWriter(destinationFile, createIfNull, false) end
    
    if not fileWriter then return nil end
    
    fileWriter:write(tostring(text))
    fileWriter:close()
end

-- Load from a sourceFile file.
-- Returns a table of Strings, representing each line in the file.
function CZ_Util.LoadFromFile(sourceFile, createIfNull)

	local contents = {}
	local fileReader = getModFileReader(CZ_Util.MOD_ID, sourceFile, createIfNull)
    --if fileReader == nil then fileReader = getFileReader(sourceFile, createIfNull) end
    
    if not fileReader then return nil end
    
	local scanLine = fileReader:readLine()
	while scanLine do
        
        table.insert(contents, tostring(scanLine))
        
		scanLine = fileReader:readLine()
		if not scanLine then break end
	end
    
	fileReader:close();
    
	return contents
end

-- Recreates the default configuration files for this mod.
function CZ_Util.recreateConfigFiles()
    local fileContents1 = CZ_Util.io_persistence.load(
        CZ_Util.DefaultSettingsFileName, 
        CZ_Util.MOD_ID)
    CZ_Util.io_persistence.store(
        CZ_Util.ConfigFileLocation, 
        CZ_Util.MOD_ID, 
        fileContents1)
    return fileContents1
end


--*********************************************
-- Custom Tables
CZ_Util.DEFAULT_SETTINGS = {
    ["FakeDead"] = {
        ["ChanceToSpawn"] = 20,
        ["HPMultiplier"] = 1000,
    },
    ["Crawler"] = {
        ["ChanceToSpawn"] = 50,
        ["HPMultiplier"] = 1000,
    },
    ["Shambler"] = {
        ["ChanceToSpawn"] = 470,
        ["HPMultiplier"] = 1000,
    },
    ["FastShambler"] = {
        ["ChanceToSpawn"] = 470,
        ["HPMultiplier"] = 1000,
    },
    ["Runner"] = {
        ["ChanceToSpawn"] = 10,
        ["HPMultiplier"] = 1000,
    },
    ["Preset"] = {
        ["PresetNum"] = 3,
    },
}

CZ_Util.configOpts = CZ_Util.io_persistence.load(CZ_Util.DefaultSettingsFileName, CZ_Util.MOD_ID)

if not CZ_Util.deepcompare(
        CZ_Util.configOpts, 
        CZ_Util.DEFAULT_SETTINGS, false) then

    CZ_Util.io_persistence.store(CZ_Util.DefaultSettingsFileName, CZ_Util.MOD_ID, CZ_Util.DEFAULT_SETTINGS)
     
    CZ_Util.configOpts = CZ_Util.io_persistence.load(CZ_Util.DefaultSettingsFileName, CZ_Util.MOD_ID)
    
end
--===============================================================================
-- Get/Setup all configuration settings from the config file.


-- [BACKWARDS COMPATIBILITY WITH OLD CONFIG SAVING SYSTEM] 
-- Get all configuration files and their settings.
local fContents = CZ_Util.LoadFromFile("MOD Config Options (CZ).lua", false)

-- Find all the values.
local foundValue = false
if fContents then
for _, fLine in pairs(fContents) do
    if fLine ~= nil then 
        if "FakeDead" == tostring(CZ_Util.split(fLine, " ")[1]) then
            if CZ_Util.isNumber(CZ_Util.split(fLine, " ")[2]) == true then
                CZ_Util.configOpts["FakeDead"]["ChanceToSpawn"] = tonumber(CZ_Util.split(fLine, " ")[2])
                foundValue = true
            end
        end
        if "Crawler" == tostring(CZ_Util.split(fLine, " ")[1]) then
            if CZ_Util.isNumber(CZ_Util.split(fLine, " ")[2]) == true then
                CZ_Util.configOpts["Crawler"]["ChanceToSpawn"] = tonumber(CZ_Util.split(fLine, " ")[2])
                foundValue = true
            end
        end
        if "Shambler" == tostring(CZ_Util.split(fLine, " ")[1]) then
            if CZ_Util.isNumber(CZ_Util.split(fLine, " ")[2]) == true then
                CZ_Util.configOpts["Shambler"]["ChanceToSpawn"] = tonumber(CZ_Util.split(fLine, " ")[2])
                foundValue = true
            end
        end
        if "FastShambler" == tostring(CZ_Util.split(fLine, " ")[1]) then
            if CZ_Util.isNumber(CZ_Util.split(fLine, " ")[2]) == true then
                CZ_Util.configOpts["FastShambler"]["ChanceToSpawn"] = tonumber(CZ_Util.split(fLine, " ")[2])
                foundValue = true
            end
        end
        if "Runner" == tostring(CZ_Util.split(fLine, " ")[1]) then
            if CZ_Util.isNumber(CZ_Util.split(fLine, " ")[2]) == true then
                CZ_Util.configOpts["Runner"]["ChanceToSpawn"] = tonumber(CZ_Util.split(fLine, " ")[2])
                foundValue = true
            end
        end
        if "Preset" == tostring(CZ_Util.split(fLine, " ")[1]) then
            if CZ_Util.isNumber(CZ_Util.split(fLine, " ")[2]) == true then
                CZ_Util.configOpts["Preset"]["PresetNum"] = tonumber(CZ_Util.split(fLine, " ")[2])
                foundValue = true
            end
        end
    end
end
end

-- Remove contents from old config file.
if fContents and foundValue == true then 
    CZ_Util.SaveToFile("MOD Config Options (CZ).lua", "", false) 
    CZ_Util.io_persistence.store(CZ_Util.ConfigFileLocation, CZ_Util.MOD_ID, CZ_Util.configOpts)
end

-- OLD CONFIG SAVING SYSTEM SUPPORT ENDS HERE


local t_restored = CZ_Util.io_persistence.load(CZ_Util.ConfigFileLocation, CZ_Util.MOD_ID)

if not CZ_Util.compare_and_insert(CZ_Util.configOpts, t_restored, true) then
     CZ_Util.io_persistence.store(CZ_Util.ConfigFileLocation, CZ_Util.MOD_ID, t_restored)
end

if t_restored then 
    CZ_Util.configOpts = t_restored 
else 
    CZ_Util.configOpts =  CZ_Util.recreateConfigFiles()
end

-- Removes this table from memory to conserve memory.
DEFAULT_SETTINGS = nil
fContents = nil

--**********************************************
-- Vanilla Functions


--*************************************
-- Custom Functions


--*************************************
-- Events



