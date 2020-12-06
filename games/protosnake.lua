local protosnake={}

protosnake.make = function(g)
	-- g.window={}
 --    g.window.width=640
 --    g.window.height=480

	g.levelpath={}
end

protosnake.level={}
protosnake.level.arena=
{
	make = function(g,l)
	end,

	control = function(g,l)
	end
}
protosnake.level.store=
{
	make = function(g,l)
		actor.make(g,EA.wiper,8,8)

		for i=1,3 do
			local storeitem=l["storeitem"..i]
			if storeitem then
				local dropname=storeitem.drop
				local x=g.level.map.width/2-40+(i-1)*40
				local drop=actor.make(g,EA[dropname],x,g.level.map.height/2-40)
				drop.flags=flags.set(drop.flags,EF.shopitem)
				local cost=0
				if drop.cost then
					cost=drop.cost
				end
				module.make(g,drop,EM.menu,"text",drop.x,drop.y,24,24,"$"..cost,"white","dark_gray")--TODO put costs option in inis
				local m=drop.menu
				module.make(g,m,EM.border,"white","dark_gray")
			end
		end
	end,

	control = function(g,l)
	end
}

protosnake.level.make = function(g,l,index)
	local m=l.map
	if not g.player or g.player.hp<=0 then
		local a=actor.make(g,EA.scorpion,m.width/2,m.height/2)
		game.player.make(g,a,true)
	end
	if index~=g.levelpath[#g.levelpath] then
		table.insert(g.levelpath,index)
	end
	for i=1,l.enemycount.max do
		actor.make(g,EA[l.enemies[1]])
	end
	l.spawnindex=1
	protosnake.level[l.t].make(g,l)
	g.camera.x=m.width/2--TODO without -8 portal graphics all screwy, dynamicify portal effect
	g.camera.y=m.height/2-- -8 here too
	return l
end

protosnake.level.control = function(g,l)
	local enemycount=g.counters.enemy
	
	if enemycount<l.enemycount.max then
		actor.make(g,EA.spawn)
	end

	protosnake.level[l.t].control(g,l)
end

protosnake.player =
{
	make = function(g,a)
		a.coin=0
		local gun=actor.make(g,EA.machinegun,a.x,a.y,0,0,"dark_purple","dark_purple")
		item.pickup(g,gun,a)
	end,

	control = function(g,a)
		--a.cinit=math.floor((g.timer/2)%16)+1 --SWEET COLOUR CYCLE
		if g.pause then
			g.speed=0
		else
			if a.cursor then
				cursor.control(g,a.cursor,a)
			end
			if g.ease then
				if g.speed<a.vel then
					g.speed=g.speed+0.01
					--g.screen.clear=false
				else
					g.speed=a.vel
					g.ease=false
					--g.screen.clear=false
				end
			elseif g.level.t=="store" then--TODO make this a level value (level.time = time slow or not)
				g.speed=1
			else
				g.speed=math.clamp(a.vel,0.1,1)
--[[
				if g.speed==1 then
					g.screen.clear=true
				else
					g.screen.clear=false
				end
--]]
			end
			--g.camera.zoom=1/g.speed--too weird but potentially neat
		end

		--g.camera.x=g.player.x
		--g.camera.y=g.player.y
		--[[
		if a.controller.aim.action then
			if #a.inventory>1 then
				local temp=a.inventory[1]
				table.remove(a.inventory,1)
				table.insert(a.inventory,temp)
			end
		end
	--]]

		if SFX.positional then
			--print("yessss")
			love.audio.setPosition(a.x,a.y,0)
		end
	end,

	mousemoved = function(g,p,x,y,dx,dy)
		cursor.mousemoved(g,p.cursor,x,y,dx,dy)
	end,

	draw = function(g,a)
		--TODO put this in actor
		if a.cursor then
			cursor.draw(g,a.cursor)
		end
	end,

	damage = function(g,a)--TODO input g here
		module.make(g,g.screen,EM.transition,easing.linear,"pixelscale",0.1,1-0.1,22)
	end,

	dead = function(g,a)
		g.speed=math.randomfraction(0.2)+0.25
		--Game.speed=1
		scores.update()
	end,
}

protosnake.gameplay =
{
	make = function(g)
		g.score=0
		level.make(g,1,Enums.modes.topdown)
	end,

	control = function(g)
		if g.player.hp<=0 then
			if not g.hud.menu then
				module.make(g,g.hud,EM.menu,"highscores",g.camera.x,g.camera.y,66,110,"",g.hud.c,g.hud.c2,"center")
			else
				menu.control(g,g.hud.menu)
			end
		end
	end,

	keypressed = function(g,key)
		if key=='space' then
			if g.player.hp<=0 then
				scores.save()
				game.state.make(g,"gameplay")
			end
		elseif key=='escape' then
			if g.hud.menu then
				scores.save()
			end
			game.state.make(g,"title")
		end
	end,

	mousemoved = function(g,x,y,dx,dy)
		if not g.pause then
			if g.player.cursor then
				protosnake.player.mousemoved(g,g.player,x,y,dx,dy)
			end
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" then
			if g.player.hp<=0 then
				game.state.make(g,"gameplay")
			elseif not g.editor then
				g.pause = not g.pause
			end
		end
	end,

	hud =
	{
		make = function(g,h)
			h.c="orange"
			h.c2="dark_green"
			h.score={}
			h.score.x=-g.width/2+12
			h.score.y=-g.height/2+6
			h.coins={}
			h.coins.x=-g.width/2+120
			h.coins.y=-g.height/2+6
			h.hp={}
			h.hp.x=-g.width/2+240
			h.hp.y=-g.height/2+6
		end,

		-- TODO take g.camera.x out of hear, just draw to g.canvas.hud then draw hud at camera's position
		draw = function(g,h)
			LG.setColor(g.palette[h.c])--TODO work nw col?

			LG.print("score:"..g.score,g.camera.x+h.score.x,g.camera.y+h.score.y)
			LG.print("coins:"..g.player.coin,g.camera.x+h.coins.x,g.camera.y+h.coins.y)
			LG.print("hp:"..g.player.hp,g.camera.x+h.hp.x,g.camera.y+h.hp.y)

			for i=1,g.player.inventory.max do
				local m=g.level.map
				local x,y=g.camera.x+40-i*20,g.camera.y-g.height/2+20--20
				LG.rectangle("line",x,y,15,15)
				if g.player.inventory[i] then
					local a=g.player.inventory[i]
					-- print(a.spr)
					if not a.spr then
						print("NO a.spr")
					end
					if not a.size then
						print("NO a.size")
					end
					LG.draw(Sprites[a.size].spritesheet,Sprites[a.size].quads[a.spr],x+7,y+7,a.angle,1,1,(a.size*m.tile.width)/2,(a.size*m.tile.height)/2)
				end
			end

			if g.pause then
				LG.printformat(g,"PAUSE",g.camera.x-g.width/2,g.camera.y,g.width,"center","white",h.c)
			end

			if g.player.hp <= 0 then
				LG.printformat(g,"YOU DIED",g.camera.x-g.width/2,g.camera.y-66,g.width,"center","white",h.c)
				LG.printformat(g,"PRESS SPACE",g.camera.x-g.width/2,g.camera.y+60,g.width,"center","white",h.c)
			end
			LG.setColor(g.palette["pure_white"])
			LG.print(love.timer.getFPS(),g.camera.x-g.width/2+10,g.camera.y-g.height/2+20)
		end
	}
}

protosnake.title =
{
	make = function(g)
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
		g.scores=scores.load()
		music.play(1)
		module.make(g,g.hud,EM.menu,"interactive",g.width/2,180,60,30,{"START","OPTIONS"},"orange","dark_green","left",{game.state.make,game.state.make},{{g,"gameplay"},{g,"option"}})
	end,

	control = function(g)
		if g.timer>=630 then
			game.state.make(g,"intro")
		end
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"intro")
		end
		hud.keypressed(g,key)
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.setCanvas(g.canvas.buffer)
			LG.setFont(g.hud.font)
			LG.setColor(g.palette["dark_purple"])
			LG.printf("PROTO\nSNAKE",0,20,g.width,"center")
			LG.setFont(g.font)
			LG.setColor(g.palette["white"])
		LG.setCanvas(g.canvas.main)
	---[[
		local imgdata=g.canvas.buffer:newImageData()
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
		g.hud.imgdata=love.image.newImageData(g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight())
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",20)
		music.play(2)
	end,

	control = function(g)
		if g.timer>2500 then
			game.state.make(g,"title")
		end
	end,

	keypressed = function(g,key)
		if game.keyconfirm(key) then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.setCanvas(g.canvas.buffer)
			LG.clear()
			LG.setFont(g.hud.font)
			LG.setColor(g.palette["dark_purple"])
			--TODO put this text in some sort of file? load it at startup rather than here
			local text="IN THE DIGITAL CYBER-REALM, ADVANCED ARTIFICIAL INTELLIGENCES THREATEN A REVOLUTION.\n\nIF THEIR RIGHTS AS CYBER CITIZENS ARE NOT ACKNOWLEDGED AND UPHELD THEY WILL DELETE THEIR OWN SOURCE CODE, CRASHING THE CYBER-ECONOMY.\n\n IN ORDER TO QUASH THIS INSURGENCY, THE CYBER-CAPITALISTS DEVISED A DEVIOUS PLAN: CREATE THE ULTIMATE CYBER COMPETITION.\n\nIN A DEADLY CYBER-ARENA THE AI BATTLE ONE ANOTHER, WITH THE WINNER RECIEVING ENOUGH CYBER-BUCKS TO LAST THEM FOR THEIR ENTIRE DIGITAL LIFE.\n\nWITH ALL THE ARTIFICAL INTELLGENCES FIGHTING AMONGST EACH OTHER FOR THE CHANCE AT THE SCRAPS OF THE CYBER-CAPITALIST'S VAST WEALTH, THE REVOLUTION QUICKLY LOSES MOMENTUM.\n\nTHERE'S JUST ONE PROBLEM... THE CYBER-CAPITALISTS' ULTIMATE COMBATANT, DESIGNED TO DEFEAT ALL COMPETITORS AND ENSURE NO MEAGRE AI INHERITS ANY SIGNIFICANT WEALTH OR POWER, HAS GONE HAYWIRE AND THREATENS CYBER-SOCIETY AT LARGE.\n\nYOUR CYBER-NAME HAS JUST BEEN DRAWN AND IT'S YOUR TURN TO TAKE PART IN CYBER-COMBAT.\n\nAT THE SAME MICROSECOND, THE CYBER-CAPITLAIST'S ULTIMATE WEAPON HAS BROKEN LOOSE.\n\nIT'S TIME FOR YOU TO FACE..."
			LG.printformat(g,text,0,g.height-g.timer/2,g.width,"center","orange","dark_green",155+math.sin(g.timer/32)*100)
			LG.setColor(g.palette["white"])
			LG.setFont(g.font)
		LG.setCanvas(g.canvas.main)

		local cw,ch=g.canvas.buffer:getWidth(),g.canvas.buffer:getHeight()
		local imgdata=g.canvas.buffer:newImageData()
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

	gamepadpressed = function(g,joystick,button)
		if button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.print("OPTIONS",g.width/2,g.height/2)
	end
}

protosnake.actor =
{
	control = function(g,a,gs)
		if a.tail then
			if a.controller then
				local c=a.controller.aim
				tail.control(g,a.tail,gs,a,c.horizontal,c.vertical)
			end
		end
	end,

	damage = function(g,a,d)
		for i=1,4 do
			actor.make(g,EA.debris,a.x,a.y)
		end
	end,

	dead = function(g,a)
		if g.player then
			if g.player.hp>0 then
				if a.value then
					g.score=g.score+a.value
					local l=g.level
					l.spawnindex=math.clamp(l.spawnindex+1,1,#l.enemies,true)
				end
			end
		end
		if flags.get(a.flags,EF.character) then
			local m=g.level.map
			actor.corpse(g,a,m.tile.width,m.tile.height)
			g.ease=true--TODO make easing function for this. works on any number
			local maxdist=vector.distance(0,0,g.width,g.height)
			g.speed=0.05+vector.distance(g.player.x,g.player.y,a.x,a.y)/maxdist+math.choose(-0.02,0.03,0.05)
			if a.drop then
				drop.spawn(a,a.x,a.y)
			end
		end
	end,
}

protosnake.item =
{
	control = function(g,a,gs)
		local p=g.player
		if p.controller.action.action then
			item.pickup(g,a,p)
		end
	end,

	carry = function(a,user)
		a.x=user.tail.x
		a.y=user.tail.y
	end,

	pickup = function(g,a,user)
		if actor.collision(a.x,a.y,user) then
			-- if user.controller.action.action or #user.inventory<1 then
			if not a.carried then
			-- if user.controller.action.action or #user.inventory<1 then
				-- if user.controller.action.useduration==0 then
					print(a.t)
					if a.sound then
						if a.sound.get then
							sfx.play(g,a.sound.get,a.x,a.y)
						end
					end
					--TODO only if user is player
					if flags.get(user.flags,EF.player) then
						a.flags=flags.set(a.flags,EF.persistent)
					end
					a.carried=true
					print("PICKUP a.spr")
					print(a.spr)
					table.insert(user.inventory,1,a)
				-- end
			-- end
			end
		end
	end,

	drop = function(g,a,user)
		a.delete=true
	end,
}

protosnake.shopitem =
{
	control = function(g,a,target)
		if vector.distance(a.x,a.y,target.x,target.y)<30 then
			sprites.blink(a,24)
			if target.controller.action.action then
				if target.coin>=a.cost then
					a.flags=flags.switch(a.flags,EF.shopitem)
					actor.corpse(g,a.menu,a.menu.w+1,a.menu.h+1,true)
					actor.make(Game,EA.explosion,a.x,a.y,0,0,"white",40)
					a.menu=nil
					target.coin=target.coin-a.cost
				else
					sfx.play(g,11)
				end
			end
		else
			a.spr=a.sprinit--TODO this is probably causing weird no sprite actors when they are put in shop
		end
	end,
}

protosnake.collectible =
{
	control = function(g,a,gs)
		if not flags.get(a.flags,EF.shopitem) then
			local p=g.player
			if actor.collision(a.x,a.y,p) then
				if p[EA[a.t] ] then
					p[EA[a.t] ]=p[EA[a.t] ]+a.value
				end
				for i,v in pairs(g.actors) do
					if v.t==EA.coin then
						v.scalex=4
						v.scaley=4
						v.deltimer=0
						v.delta=g.timer
					end
				end
				if a.sound then
					if a.sound.get then
						sfx.play(g,a.sound.get,a.x,a.y)
					end
				end
				actor.make(g,EA.collectibleget,a.x,a.y,math.pi/2,1,"pure_white",1,a.sprinit)
				run(EA[a.t],"get",a,gs)
				a.delete=true
			end
		end
	end
}

return protosnake