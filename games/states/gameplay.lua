local function control(g)
	local s=g.state

	if _G[Enums.games.states.gameplays[g.state.st]]["control"] then
		_G[Enums.games.states.gameplays[g.state.st]]["control"](g)
	end

	sfx.update(SFX,g.speed)

	if not g.pause then
		for i,v in ipairs(g.actors) do
			if not v.delete then
				actor.control(g,v,g.speed)
			end
		end
	end

--[[
	if g.transition then
		transition.control(g,g.transition)
	end
--]]

	camera.control(g.camera,g.speed)
	
	for i,v in ipairs(g.actors) do
		if v.delete==true then
			if v.inventory then
				for j,k in ipairs(v.inventory) do
					k.delete=true
				end
			end
			counters.update(g,g.counters,v,-1)
			table.remove(g.actors,i)
		end
	end

	if g.levels then
		if g.levels.current then
			level.control(g,g.levels.current)
		end
	end
end

return
{
	control = control,
}