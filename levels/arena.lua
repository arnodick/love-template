local function make(l)
	local ea=Enums.actors
	for i=1,l.enemies.max do
		--actor.make(ea.character,l.enemies[1])
		actor.make(ea.effect,ea.effects.spawn)
		table.remove(l.enemies,1)
	end
end

local function control(l)

end

return
{
	load = load,
	make = make,
	control = control,
}