local protosnake={}

protosnake.make = function(g,tw,th,gw,gh,sp)
	level.load(g,"games/levels/protosnake")
	g.levelpath={}
end

protosnake.level={}
protosnake.level.arena=
{
	make = function(g,l)
		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		l.map=map.generate("walls",mw+2,mh+2)
	end,

	control = function(g,l)
	end
}
protosnake.level.store=
{
	make = function(g,l)
		actor.make(g,EA[g.name].wiper,0,5)

		for i=1,3 do
			local storeitem=l["storeitem"..i]
			if storeitem then
				local dropname=storeitem.drop
				local x=g.width/2-40+(i-1)*40
				--local drop=actor.make(g,love.math.random(#EA[g.name]),x,g.height/2-40)
				local drop=actor.make(g,EA[g.name][dropname],x,g.height/2-40)
				drop.flags=flags.set(drop.flags,EF.shopitem)
				local cost=0
				if drop.cost then
					cost=drop.cost
				end

				module.make(drop,EM.menu,EMM.text,drop.x,drop.y,24,24,"$"..cost,EC.white,EC.dark_gray)--TODO put costs option in inis
				local m=drop.menu
				module.make(m,EM.border,EC.white,EC.dark_gray)
			end
		end
		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		l.map=map.generate("walls",mw+2,mh+2)
	end,

	control = function(g,l)
	end
}

protosnake.level.make = function(g,l,index)
	--TODO maybe get rid of all this with json?
	if index~=g.levelpath[#g.levelpath] then
		table.insert(g.levelpath,index)
	end
	local lload=g.levels[index]

	l.t=lload.values.t
	l.c=lload.values.c
	l.enemies={}
	for i,v in pairs(lload.enemies) do
		if type(i)=="number" then
			l.enemies[i]=EA[g.name][v]
		else
			l.enemies[i]=v
		end
	end

	l.actordrops=lload.actordrops
	l.portal1=lload.portal1
	l.portal2=lload.portal2
	l.portalstore=lload.portalstore

	l.storeitem1=lload.storeitem1
	l.storeitem2=lload.storeitem2
	l.storeitem3=lload.storeitem3

	for i=1,l.enemies.max do
		actor.make(g,l.enemies[1])
	end

	l.spawnindex=1

	protosnake.level[l.t].make(g,l)
	return l
end

protosnake.level.control = function(g,l)
	local enemycount=g.counters.enemy
	
	if enemycount<l.enemies.max then
		actor.make(g,EA[g.name].spawn)
	end

	protosnake.level[l.t].control(g,l)
end

protosnake.level.draw = function(g,l)
	--map.draw(l.map,"grid")
	map.draw(l.map,{"grid","sprites"})
end

protosnake.gameplay =
{
	make = function(g)
		g.score=0
		--hud.make(g,EM.huds.protosnake_hud)
		hud.make(g,"gameplay")
		g.player=actor.make(g,EA[g.name].player,g.width/2,g.height/2)
		--module.make(a,EM.player)

		level.make(g,1,Enums.games.modes.topdown)
	end,

	control = function(g)
		if g.player.hp<=0 then
			if not g.hud.menu then
				module.make(g.hud,EM.menu,EMM.highscores,g.width/2,g.height/2,66,100,"",g.hud.c,g.hud.c2,"center")
			end
		end
	end,

	keypressed = function(g,key)
		if key=='space' then
			if g.player.hp<=0 then
				game.state.make(g,"gameplay")
			end
		elseif key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" then
			if g.player.hp<=0 then
				game.state.make(g,"gameplay")
			elseif not g.editor then
				g.pause = not g.pause
			end
		end
	end
}

protosnake.title =
{
	make = function(g)
		hud.make(g)
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
		g.scores=scores.load()
		music.play(1)
		module.make(g.hud,EM.menu,EMM.interactive,g.width/2,180,60,30,{"START","OPTIONS"},EC.orange,EC.dark_green,"left",{game.state.make,game.state.make},{{g,"gameplay"},{g,"option"}})
	end,

	control = function(g)
		menu.control(g.hud.menu)
		if g.timer>=630 then
			game.state.make(g,"intro")
		end
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
		local m=g.hud.menu
		if m then
			menu.gamepadpressed(m,button)
		end
	end,

	draw = function(g)
		LG.setCanvas(g.canvas.buffer)
			LG.setFont(g.hud.font)
			LG.setColor(g.palette[EC.dark_purple])
			LG.printf("PROTO\nSNAKE",0,20,g.width,"center")
			LG.setFont(g.font)
			LG.setColor(g.palette[EC.white])
			menu.draw(g.hud.menu)
			--LG.printf("PRESS SPACE",0,180,g.width,"center")
		LG.setCanvas(g.canvas.main)
	---[[
		local imgdata=g.canvas.buffer:newImageData(0,0,g.canvas.buffer:getWidth()-1,g.canvas.buffer:getHeight()-1)
		imgdata:mapPixel(pixelmaps.sparkle)
		imgdata:mapPixel(pixelmaps.crush)
		local image=LG.newImage(imgdata)
		love.graphics.draw(image,0,0,0,1,1,0,0,0,0)
	--]]

	end
}

protosnake.intro =
{
	make = function(g)
		hud.make(g)
		g.hud.imgdata=love.image.newImageData(g.canvas.buffer:getWidth()-1,g.canvas.buffer:getHeight()-1)
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",20)
		music.play(2)
	end,

	control = function(g)
		if g.timer>2500 then
			game.state.make(g,"title")
		end
	end,

	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"title")
		elseif key == 'escape' then
			love.event.quit()
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.setCanvas(g.canvas.buffer)
			LG.clear()
			LG.setFont(g.hud.font)
			LG.setColor(g.palette[EC.dark_purple])
			local text="IN THE DIGITAL CYBER-REALM, ADVANCED ARTIFICIAL INTELLIGENCES THREATEN A REVOLUTION.\n\nIF THEIR RIGHTS AS CYBER CITIZENS ARE NOT ACKNOWLEDGED AND UPHELD THEY WILL DELETE THEIR OWN SOURCE CODE, CRASHING THE CYBER-ECONOMY.\n\n IN ORDER TO QUASH THIS INSURGENCY, THE CYBER-CAPITALISTS DEVISED A DEVIOUS PLAN: CREATE THE ULTIMATE CYBER COMPETITION.\n\nIN A DEADLY CYBER-ARENA THE AI BATTLE ONE ANOTHER, WITH THE WINNER RECIEVING ENOUGH CYBER-BUCKS TO LAST THEM FOR THEIR ENTIRE DIGITAL LIFE.\n\nWITH ALL THE ARTIFICAL INTELLGENCES FIGHTING AMONGST EACH OTHER FOR THE CHANCE AT THE SCRAPS OF THE CYBER-CAPITALIST'S VAST WEALTH, THE REVOLUTION QUICKLY LOSES MOMENTUM.\n\nTHERE'S JUST ONE PROBLEMM... THE CYBER-CAPITALISTS' ULTIMATE COMBATANT, DESIGNED TO DEFEAT ALL COMPETITORS AND ENSURE NO MEAGRE AI INHERITS ANY SIGNIFICANT WEALTH OR POWER, HAS GONE HAYWIRE AND THREATENS CYBER-SOCIETY AT LARGE.\n\nYOUR CYBER-NAME HAS JUST BEEN DRAWN AND IT'S YOUR TURN TO TAKE PART IN CYBER-COMBAT.\n\nAT THE SAME MICROSECOND, THE CYBER-CAPITLAIST'S ULTIMATE WEAPON HAS BROKEN LOOSE.\n\nIT'S TIME FOR YOU TO FACE..."
			LG.printformat(text,0,g.height-g.timer/2,g.width,"center",EC.orange,EC.dark_green,155+math.sin(g.timer/32)*100)
			LG.setColor(g.palette[EC.white])
			LG.setFont(g.font)
		LG.setCanvas(g.canvas.main)

		local cw,ch=g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight()
		local imgdata=g.canvas.buffer:newImageData(0,0,cw-1,ch-1)
		imgdata:mapPixel(pixelmaps.crush)
		local iw,ih=imgdata:getWidth(),imgdata:getHeight()
		local mid=math.floor(iw/2)
		
		for x = iw-1,0,-1 do
			local xoff=x-mid
		    for y = ih-1,0,-1  do
				local ynorm=y/ih
				local xoffsquish=xoff*ynorm
				local xsquish=math.clamp(math.floor(mid+xoffsquish),0,iw-1)
				local r,gr,b,a = imgdata:getPixel(x,y)
				g.hud.imgdata:setPixel(xsquish,y,r,gr,b,a)
		    end
		end
		local image=LG.newImage(g.hud.imgdata)
		love.graphics.draw(image,g.width/2,g.height/2,math.sin(g.timer/100)/3,1,1,g.width/2,g.height/2,0,0)
	end,
}

protosnake.option =
{
	make = function(g)
		music.play(1)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("OPTIONS",g.width/2,g.height/2)
	end
}

protosnake.hud={}
protosnake.hud.make = function(h)
	protosnake.hud[h.t].make(h)
end
protosnake.hud.draw = function(g,h)
	protosnake.hud[h.t].draw(g,h)
end

protosnake.hud.gameplay =
{
	make = function(h)
		h.c=EC.orange
		h.c2=EC.dark_green
		h.score={}
		h.score.x=-Game.width/2+12
		h.score.y=-Game.height/2+6
		h.coins={}
		h.coins.x=-Game.width/2+120
		h.coins.y=-Game.height/2+6
		h.hp={}
		h.hp.x=-Game.width/2+240
		h.hp.y=-Game.height/2+6
		print("OTHER IT HAPPENED")
	end,

	draw = function(g,h)
		LG.setColor(g.palette[h.c])

		LG.print("score:"..g.score,g.camera.x+h.score.x,g.camera.y+h.score.y)
		LG.print("coins:"..g.player.coin,g.camera.x+h.coins.x,g.camera.y+h.coins.y)
		LG.print("hp:"..g.player.hp,g.camera.x+h.hp.x,g.camera.y+h.hp.y)

		for i=1,g.player.inventory.max do
			local x,y=g.camera.x+40-i*20,20
			LG.rectangle("line",x,y,15,15)
			if g.player.inventory[i] then
				local a=g.player.inventory[i]
				LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*g.tile.width)/2,(a.size*g.tile.height)/2)
			end
		end

		if g.pause then
			LG.printformat("PAUSE",g.camera.x-g.width/2,g.camera.y,g.width,"center",EC.white,h.c)
		end

		if g.player.hp <= 0 then
			LG.printformat("YOU DIED",g.camera.x-g.width/2,g.camera.y-66,g.width,"center",EC.white,h.c)
			LG.printformat("PRESS SPACE",g.camera.x-g.width/2,g.camera.y+60,g.width,"center",EC.white,h.c)
		end
		LG.setColor(g.palette[EC.pure_white])
		LG.print(love.timer.getFPS(),10,10)
	end
}

--this is run when an actor in the game loses all its HP
protosnake.dead = function(g,a)
	if g.player then
		if g.player.hp>0 then
			if a.value then
				g.score=g.score+a.value
				local l=g.level
				l.spawnindex=math.clamp(l.spawnindex+1,1,#l.enemies,true)
			end
		end
	end
end

return protosnake