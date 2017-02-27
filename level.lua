local function load(l)

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
	
	if enemycount<l.enemies.max then
		actor.make(Enums.actors.effect,Enums.actors.effects.spawn)
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