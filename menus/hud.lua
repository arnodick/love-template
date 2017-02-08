local function make(hud)
	hud.c=Enums.colours.yellow
	hud.score={}
	hud.score.x=12
	hud.score.y=6
	hud.hp={}
	hud.hp.x=240
	hud.hp.y=6
end

local function control(h)

end

local function keypressed(i,key)
	if key=='space' then
		Game.settings=game.changestate(Enums.states.game)
	end
end

local function draw(h)
	love.graphics.setColor(Palette[h.c])
	
	love.graphics.print("score:"..Score,Camera.x+h.score.x,Camera.y+h.score.y)

	love.graphics.print("hp:"..Player.hp,Camera.x+h.hp.x,Camera.y+h.hp.y)
	if Player.hp <= 0 then
		love.graphics.print("YOU DIED",Camera.x+140,Camera.y+50)
		love.graphics.print("PRESS SPACE",Camera.x+140,Camera.y+80)
	end
	--love.graphics.setColor(Palette[Enums.colours.pure_white])
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}