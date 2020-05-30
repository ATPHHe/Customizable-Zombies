-- Persistent Data (for CustomizableZombies)
local multiRefObjects = {

} -- multiRefObjects

-- "ChanceToSpawn" -    1000    = 100%
-- "ChanceToSpawn" -    500     = 50%
-- "ChanceToSpawn" -    1       = 0.1%
-- "HPMultiplier" -     1000    = 1.000
-- "HPMultiplier" -     4000    = 4.000
-- "HPMultiplier" -     1       = 0.001
local obj1 = {
	["FakeDead"] = {
		["ChanceToSpawn"] = 20;
		["HPMultiplier"] = 1000;
	};
	["Crawler"] = {
		["ChanceToSpawn"] = 50;
		["HPMultiplier"] = 1000;
	};
	["Shambler"] = {
		["ChanceToSpawn"] = 470;
		["HPMultiplier"] = 1000;
	};
	["FastShambler"] = {
		["ChanceToSpawn"] = 470;
		["HPMultiplier"] = 1000;
	};
	["Runner"] = {
		["ChanceToSpawn"] = 10;
		["HPMultiplier"] = 1000;
	};
	["Preset"] = {
		["PresetNum"] = 3;
	};
	["Version"] = "2.3.0";
}
return obj1
