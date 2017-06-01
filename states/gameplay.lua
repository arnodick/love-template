local function make(g)
	if _G[Enums.states.gameplays[g.state.st]]["make"] then
		_G[Enums.states.gameplays[g.state.st]]["make"](g)
	end
end

local function control(g)
	local s=g.state
	sfx.update(SFX,g.speed)

	if not g.pause then
		for i,v in ipairs(g.actors) do
			if not v.delete then
				actor.control(v,g.speed)
			end
		end
	end

	camera.control(g.camera,Player,g.speed)
	
	for i,v in ipairs(g.actors) do
		if v.delete==true then
			if v.inventory then
				for j,k in ipairs(v.inventory) do
					k.delete=true
				end
			end
			counters.update(g.counters,v,-1)
			table.remove(g.actors,i)
		end
	end

	if _G[Enums.states.gameplays[g.state.st]]["control"] then
		_G[Enums.states.gameplays[g.state.st]]["control"](g)
	end

	level.control(g.levels.current)
end

local function keypressed(g,key)
	if _G[Enums.states.gameplays[g.state.st]]["keypressed"] then
		_G[Enums.states.gameplays[g.state.st]]["keypressed"](g,key)
	end
end

local function gamepadpressed(g,button)
	if _G[Enums.states.gameplays[g.state.st]]["gamepadpressed"] then
		_G[Enums.states.gameplays[g.state.st]]["gamepadpressed"](g,button)
	end
end

local function draw(g)
	local s=g.state

	if g.map then
		map.draw(g.map)
	end

	for i,v in ipairs(g.actors) do
		if not v.delete then
			actor.draw(v)
		end
	end

	if s.hud then
		hud.draw(g,s.hud)
	end

	if _G[Enums.states.gameplays[g.state.st]]["draw"] then
		_G[Enums.states.gameplays[g.state.st]]["draw"](g)
	end
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}