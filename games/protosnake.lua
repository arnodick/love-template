local protosnake={}
--[[
protosnake.intro={}
protosnake.title={}
protosnake.option={}
protosnake.gameplay={}


protosnake.gameplay=
{
	make = function(g)
		
	end
}
--]]

protosnake.make = function(g,tw,th,gw,gh,sp)
	level.load(g,"games/levels/protosnake/inis")
	g.levelpath={}

	--game.state.make(g,Enums.games.states.intro)
end

return protosnake