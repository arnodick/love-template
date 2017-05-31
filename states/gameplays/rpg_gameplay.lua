local function make(g)

end

local function control(g)

end

local function keypressed(g,key)
	if key=='escape' then
		game.state.make(g,Enums.states.title)
	end
end

local function gamepadpressed(g,button)

end

local function draw(g)
	local s=g.state

	map.draw(g.map)
	for i,v in ipairs(g.actors) do
		if not v.delete then
			actor.draw(v)
		end
	end

	if s.hud then
		hud.draw(g,s.hud)
	end
	LG.print("rpg gameplay", g.width/2, g.height/2)
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}