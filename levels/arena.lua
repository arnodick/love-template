local function make(l)
	local ea=Enums.actors
	actor.make(ea.effect,ea.effects.portal)
--[[
	for i=1,l.enemies.max do
		actor.make(ea.character,l.enemies[1])
	end
--]]
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}