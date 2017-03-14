local function make(hud)
	hud.c=EC.orange
	hud.c2=EC.dark_green
	--hud.c=love.math.random(#Palette)
	--hud.c2=love.math.random(#Palette)
	hud.score={}
	hud.score.x=12
	hud.score.y=6
	hud.coins={}
	hud.coins.x=120
	hud.coins.y=6
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
		--else
			--Screen.pixeltrans=true
		end
	end
end

local function draw(h)
	love.graphics.setColor(Palette[h.c])
	
	love.graphics.print("score:"..Game.settings.score,Camera.x+h.score.x,Camera.y+h.score.y)
	love.graphics.print("coins:"..Player.coin,Camera.x+h.coins.x,Camera.y+h.coins.y)
	love.graphics.print("hp:"..Player.hp,Camera.x+h.hp.x,Camera.y+h.hp.y)
	for i=1,Player.inv.max do
		local x,y=Game.width/2+40-i*20,20
		love.graphics.rectangle("line",x,y,15,15)
		if Player.inv[i] then
			local a=Player.inv[i]
			love.graphics.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
		end
	end
	if Player.hp <= 0 then
		--love.graphics.print("YOU DIED",Camera.x+140,Camera.y+20)
		love.graphics.printborder("YOU DIED",Camera.x+140,Camera.y+20,EC.white,h.c)
		love.graphics.print("PRESS SPACE",Camera.x+135,Camera.y+50)
		scores.draw(Camera.x+150,Camera.y+70,h.c,h.c2)
	end

	love.graphics.setColor(Palette[EC.pure_white])
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	draw = draw,
}