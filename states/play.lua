local function make(g)
	g.state.c=EC.orange
	g.state.c2=EC.dark_green
	--g.state.c=love.math.random(#g.palette)
	--g.state.c2=love.math.random(#g.palette)
	g.state.score={}
	g.state.score.x=12
	g.state.score.y=6
	g.state.coins={}
	g.state.coins.x=120
	g.state.coins.y=6
	g.state.hp={}
	g.state.hp.x=240
	g.state.hp.y=6

	g.score=0

	local mw,mh=g.width/g.tile.width,g.height/g.tile.height
	g.map=map.generate(mw+2,mh+2)

	Player=actor.make(EA.player,g.width/2,g.height/2)

	g.level=1
	g.levels.current=level.make(g.level)
end

local function control(g)
	local s=g.state
	sfx.update(SFX,g.speed)

	if not g.pause then
		for i,v in ipairs(g.actors) do
			if not v.delete then
				actor.control(v,g.speed)
			end
		end
	end

	camera.control(g.camera,Player,g.speed)
	
	for i,v in ipairs(g.actors) do
		if v.delete==true then
			if v.inventory then
				for j,k in ipairs(v.inventory) do
					k.delete=true
				end
			end
			counters.update(g.counters,v,-1)
			table.remove(g.actors,i)
		end
	end

	if Player.hp<=0 then
		if not s.menu then
			module.make(s,EM.menu,EMM.highscores,g.width/2,g.height/2,66,100,"",s.c,s.c2,"center")
		end
	end

	level.control(g.levels.current)
end

local function keypressed(g,key)
	if key=='space' then
		if Player.hp<=0 then
			game.state.make(g,Enums.states.play)
		--[[
		else
			Screen.pixeltrans=true
			if g.camera.zoom==1 then
				g.camera.zoom=2
			else
				g.camera.zoom=1
			end
		
			g.levels.current=level.make("store")
		--]]
		end
	elseif key=='escape' then
		game.state.make(g,Enums.states.title)
	end
end

local function gamepadpressed(g,button)
	if button=="start" then
		if Player.hp<=0 then
			game.state.make(g,Enums.states.play)
		else
			g.pause = not g.pause
		end
	end
end

local function draw(g)
	local s=g.state

	map.draw(g.map)
	for i,v in ipairs(g.actors) do
		if not v.delete then
			actor.draw(v)
		end
	end

	LG.setColor(g.palette[s.c])
	
	LG.print("score:"..g.score,g.camera.x+s.score.x,g.camera.y+s.score.y)
	LG.print("coins:"..Player.coin,g.camera.x+s.coins.x,g.camera.y+s.coins.y)
	LG.print("hp:"..Player.hp,g.camera.x+s.hp.x,g.camera.y+s.hp.y)
	for i=1,Player.inventory.max do
		local x,y=g.width/2+40-i*20,20
		LG.rectangle("line",x,y,15,15)
		if Player.inventory[i] then
			local a=Player.inventory[i]
			LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*g.tile.width)/2,(a.size*g.tile.height)/2)
		end
	end

	if g.pause then
		LG.printformat("PAUSE",g.camera.x+140,g.camera.y+g.height/2,g.width,"left",EC.white,s.c)
	end

	if Player.hp <= 0 then
		LG.printformat("YOU DIED",0,g.height/2-66,g.width,"center",EC.white,s.c)
		LG.printformat("PRESS SPACE",0,g.height/2+60,g.width,"center",EC.white,s.c)
		menu.draw(s.menu)
	end

	LG.setColor(g.palette[EC.pure_white])
end

return
{
	make = make,
	control = control,
	keypressed = keypressed,
	gamepadpressed = gamepadpressed,
	draw = draw,
}