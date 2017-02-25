local function load(l)
	l.t=t
	l.enemies={}
	l.enemies.max=5
	l.enemies.spawntimer=0
	if _G[Enums.levels[l.t]]["load"] then
		_G[Enums.levels[l.t]]["load"](l,gs)
	end
end

local function make(num,levels)
	local l={}
	local lload=levels[num]
	l.t=lload.t
	l.enemies=lload.enemies
	if _G[Enums.levels[l.t]]["make"] then
		_G[Enums.levels[l.t]]["make"](l,gs)
	end
	return l
end

local function control(l)
	local enemycount=Game.settings.counters.enemies
--[[
	for i,v in pairs(Actors) do
		if v.t==Enums.actors.character then
			if flags.get(v.flags,Enums.flags.enemy) then
				enemycount=enemycount+1
			end
		end
	end
--]]
	print(enemycount)
	if enemycount<l.enemies.max then
		if #l.enemies>0 then
			actor.make(Enums.actors.character,l.enemies[1])--TODO make level.spawnenemy or something
			table.remove(l.enemies,1)
		end
	end
	if _G[Enums.levels[l.t]]["control"] then
		_G[Enums.levels[l.t]]["control"](l,gs)
	end
end

return
{
	load = load,
	make = make,
	control = control,
}