local function make(s)
	s.c=EC.orange
	s.c2=EC.dark_green
	--s.c=love.math.random(#Palette)
	--s.c2=love.math.random(#Palette)
	s.score={}
	s.score.x=12
	s.score.y=6
	s.coins={}
	s.coins.x=120
	s.coins.y=6
	s.hp={}
	s.hp.x=240
	s.hp.y=6
end

local function control(g,s)
	sfx.update(SFX,g.speed)

	if not g.pause then
		for i,v in ipairs(g.actors) do
			actor.control(v,g.speed)
		end
	end

	camera.control(g.camera,Player,g.speed)
	
	for i,v in ipairs(g.actors) do
		if v.delete==true then
			if v.inv then
				v.inv[1].delete=true
			end
			counters.update(g.counters,v,-1)
			table.remove(g.actors,i)
		end
	end

	level.control(g.levels.current)
end

local function keypressed(g,s,key)
	if key=='space' then
		if Player.hp<=0 then
			game.changestate(g,Enums.states.play)
		--else
			--Screen.pixeltrans=true
		end
	elseif key=='escape' then
		game.changestate(g,Enums.states.title)
	end
end

local function gamepadpressed(g,s,button)
	if button=="start" then
		g.pause = not g.pause
	end
end

local function draw(g,s)
	map.draw(g.map)
	for i,v in ipairs(g.actors) do
		actor.draw(v)
	end

	LG.setColor(Palette[s.c])
	
	LG.print("score:"..Game.score,Game.camera.x+s.score.x,Game.camera.y+s.score.y)
	LG.print("coins:"..Player.coin,Game.camera.x+s.coins.x,Game.camera.y+s.coins.y)
	LG.print("hp:"..Player.hp,Game.camera.x+s.hp.x,Game.camera.y+s.hp.y)
	for i=1,Player.inv.max do
		local x,y=Game.width/2+40-i*20,20
		LG.rectangle("line",x,y,15,15)
		if Player.inv[i] then
			local a=Player.inv[i]
			LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
		end
	end

	if Game.pause then
		LG.printborder("PAUSE",Game.camera.x+140,Game.camera.y+Game.height/2,EC.white,s.c)
	end

	if Player.hp <= 0 then
		LG.printborder("YOU DIED",Game.camera.x+140,Game.camera.y+20,EC.white,s.c)
		LG.print("PRESS SPACE",Game.camera.x+135,Game.camera.y+50)
		scores.draw(Game.camera.x+150,Game.camera.y+70,s.c,s.c2)
	end

	LG.setColor(Palette[EC.pure_white])
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}