local function control(g)
	local s=g.state

	if _G[Enums.games.states.gameplays[g.state.st]]["control"] then
		_G[Enums.games.states.gameplays[g.state.st]]["control"](g)
	end
end

return
{
	--control = control,
}