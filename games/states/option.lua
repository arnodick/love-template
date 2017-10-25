local function control(g)
	if _G[Enums.games.states.options[g.state.st]]["control"] then
		_G[Enums.games.states.options[g.state.st]]["control"](g)
	end
end

local function draw(g)
	if _G[Enums.games.states.options[g.state.st]]["draw"] then
		_G[Enums.games.states.options[g.state.st]]["draw"](g)
	end
end

return
{
	control = control,
	draw = draw,
}