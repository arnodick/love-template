local function load()
	if not love.filesystem.exists("scores.ini") then
		local scores=
		{
			high={0,0,0,0,0,0,0,0}
		}
		
		LIP.save("scores.ini",scores)
	end
	return LIP.load("scores.ini")
end

local function save()
	local scores=scores.load()
	local score=Game.settings.score
	local function scoresort(a,b)
		if a>b then
			return true
		else
			return false
		end
	end
	table.insert(scores.high,score)
	table.sort(scores.high,scoresort)
	for i=#scores.high,1,-1 do
		if i>8 then
			table.remove(scores.high,i)
		end
	end
	LIP.save("scores.ini",scores)
--[[
	if Game.settings.score > scores.high[1] then
		scores.high[1] = Game.settings.score
		LIP.save("scores.ini",scores)
	end
--]]
end

return
{
	load = load,
	save = save,
}