local function make(hud)
	hud.c=Enums.colours.orange
	hud.c2=Enums.colours.dark_green
	--hud.c=love.math.random(#Palette)
	--hud.c2=love.math.random(#Palette)
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
		if Player.hp<=0 then
			Game.settings=game.changestate(Enums.states.play)
		end
	end
end

local function draw(h)
	local colours=Enums.colours
	love.graphics.setColor(Palette[h.c])
	
	love.graphics.print("score:"..Game.settings.score,Camera.x+h.score.x,Camera.y+h.score.y)

	love.graphics.print("hp:"..Player.hp,Camera.x+h.hp.x,Camera.y+h.hp.y)
	if Player.hp <= 0 then
		--love.graphics.print("YOU DIED",Camera.x+140,Camera.y+20)
		love.graphics.printborder("YOU DIED",Camera.x+140,Camera.y+20,colours.white,h.c)
		love.graphics.print("PRESS SPACE",Camera.x+135,Camera.y+50)
		scores.draw(Camera.x+150,Camera.y+70,h.c,h.c2)
	end

	love.graphics.setColor(Palette[Enums.colours.pure_white])
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}