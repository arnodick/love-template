local function make(g)
	g.states.c=EC.orange
	g.states.c2=EC.dark_green
	--g.states.c=love.math.random(#Palette)
	--g.states.c2=love.math.random(#Palette)
	g.states.score={}
	g.states.score.x=12
	g.states.score.y=6
	g.states.coins={}
	g.states.coins.x=120
	g.states.coins.y=6
	g.states.hp={}
	g.states.hp.x=240
	g.states.hp.y=6
end

local function control(g)
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

local function change(g,s)
	LG.setCanvas(g.canvas.buffer)
	LG.clear()
	g.score=0

	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate(mw+2,mh+2)

	Player=actor.make(EA.character,EA.characters.player,g.width/2,g.height/2)

	g.level=1
	g.levels.current=level.make(g.levels[g.level])
end

local function keypressed(g,key)
	if key=='space' then
		if Player.hp<=0 then
			game.state.change(g,Enums.states.play)
		--else
			--Screen.pixeltrans=true
		end
	elseif key=='escape' then
		game.state.change(g,Enums.states.title)
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		g.pause = not g.pause
	end
end

local function draw(g)
	local s=g.states

	map.draw(g.map)
	for i,v in ipairs(g.actors) do
		actor.draw(v)
	end

	LG.setColor(Palette[s.c])
	
	LG.print("score:"..g.score,g.camera.x+s.score.x,g.camera.y+s.score.y)
	LG.print("coins:"..Player.coin,g.camera.x+s.coins.x,g.camera.y+s.coins.y)
	LG.print("hp:"..Player.hp,g.camera.x+s.hp.x,g.camera.y+s.hp.y)
	for i=1,Player.inv.max do
		local x,y=g.width/2+40-i*20,20
		LG.rectangle("line",x,y,15,15)
		if Player.inv[i] then
			local a=Player.inv[i]
			LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*g.tile.width)/2,(a.size*g.tile.height)/2)
		end
	end

	if g.pause then
		LG.printborder("PAUSE",g.camera.x+140,g.camera.y+g.height/2,EC.white,s.c)
	end

	if Player.hp <= 0 then
		LG.printborder("YOU DIED",g.camera.x+140,g.camera.y+20,EC.white,s.c)
		LG.print("PRESS SPACE",g.camera.x+135,g.camera.y+50)
		scores.draw(g.camera.x+150,g.camera.y+70,s.c,s.c2)
	end

	LG.setColor(Palette[EC.pure_white])
end

return
{
	make = make,
	control = control,
	change = change,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}