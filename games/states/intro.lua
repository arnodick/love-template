local function control(g)
	if _G[Enums.games.states.intros[g.state.st]]["control"] then
		_G[Enums.games.states.intros[g.state.st]]["control"](g)
	end
end

return
{
	--control = control,
}