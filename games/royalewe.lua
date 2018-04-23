local royalewe={}

royalewe.level = 
{
	make = function(g,l)
		local m=l.map

		for i=1,199 do
			actor.make(g,EA.person,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)
		end
---[[
		for i=1,20 do
			actor.make(g,EA.handgun,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)
		end
--]]
		for i=1,50 do
			actor.make(g,EA.the_coin,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)
		end

		actor.make(g,EA.minigun,love.math.random(m.w)*m.tile.width,love.math.random(m.h)*m.tile.height)

		g.score=0
	end
}

royalewe.player =
{
	make = function(g,a)
		local playernum=#g.players
		print("player count: "..playernum)

		if #Joysticks>0 then
			module.make(a,EM.controller,EMC.move,EMCI.gamepad,1)
			module.make(a,EM.controller,EMC.aim,EMCI.gamepad,1)
			module.make(a,EM.controller,EMC.action,EMCI.gamepad,1)
		end
		a.desires=nil
		a.the_coin=0
	end,

	control = function(g,a)
		g.camera.x=a.x
		g.camera.y=a.y
		love.audio.setPosition(a.x,a.y,0)
	end,
--[[
	draw = function(g,a)
		local m=g.level.map
		local tw,th=m.tile.width,m.tile.height
		local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
		for my=1,30 do
			for mx=1,40 do
				local cx,cy=map.getcell(m,a.x+(mx-20)*tw,a.y+(my-15)*th)
				if flags.get(m[cy][cx],EF.animated,16) then
					cx,cy=(cx-1)*tw,(cy-1)*th
					LG.setCanvas(g.level.canvas.background)
						LG.setBlendMode("replace")
						LG.translate(xcamoff,ycamoff)
							local v=map.getcellvalue(m,cx,cy)
							if math.floor(g.timer/20)%2==0 then
								LG.draw(Spritesheet[1],Quads[1][v+1],cx,cy)
							else
								LG.draw(Spritesheet[1],Quads[1][v],cx,cy)
							end
						LG.translate(-xcamoff,-ycamoff)
						LG.setBlendMode("alpha")
					LG.setCanvas(g.canvas.main)
				end
			end
		end
	end,
--]]
	damage = function(g,a)
		g.screen.shake=30
	end,

	dead = function(g,a)
		g.score=g.score+a.the_coin
	end,

}

royalewe.make = function(g)
	
end

royalewe.gameplay =
{
	make = function(g)
		love.keyboard.setTextInput(false)
		level.make(g,1,Enums.modes.topdown_tank)

		g.starttimer=0
		g.countdown=false

			--actor.make(g,EA.handgun,a.x,a.y)
		--actor.make(g,EA.witch,map.width(m)/2-5,map.height(m)/2-5)
		--actor.load(g,"person",map.width(m)/2-5,map.height(m)/2-5)
		g.camera.zoom=1
	end,

	control = function(g)
		if g.countdown then
			g.starttimer=g.starttimer+1
			if g.starttimer>180 then
				if #Joysticks>#g.players then
					local m=g.level.map

					local a=supper.random(g.actors.persons)
					player.make(g,a)
				end
				g.countdown=false
			end
		elseif not g.camera.transition and g.starttimer==0 then
				--module.make(g.camera,EM.target,18,100)
--module.make(g.camera,EM.transition,easing.linear,"zoom",g.camera.zoom,4,d)
				local upordown=love.math.random(2)
				if upordown==1 then
					local dest=love.math.random(g.level.map.width)
					local move=dest-g.camera.x
					module.make(g.camera,EM.transition,easing.linear,"x",g.camera.x,move,120)
				else
					local dest=love.math.random(g.level.map.height)
					local move=dest-g.camera.y
					module.make(g.camera,EM.transition,easing.linear,"y",g.camera.y,move,120)
				end
		end
		local m=g.level.map
--[[
		local cycles=g.level.timer.cycles
		if cycles<m.w/2 then
			if g.actors.persons then
				if #g.actors.persons<50 then
					for i=1,50 do
						actor.make(g,EA.person,love.math.random(cycles,m.w-cycles)*m.tile.width,love.math.random(cycles,m.h-cycles)*m.tile.height)
					end
				end
			end
		end
--]]
		if not g.pause and not g.countdown and g.starttimer~=0 then
			local gs=g.speed
			if g.level.timer.count>=g.level.timer.limit then
				g.level.timer.count=0
				g.level.timer.cycles=g.level.timer.cycles+1
				sfx.play(7,g.camera.x,g.camera.y)
				g.level.draw=true
			elseif g.level.timer.cycles<m.w/2 then
				g.level.timer.count=g.level.timer.count+gs
			end
		end
		if #g.actors.persons<=1 then
			--g.pause=true
			if g.players[1] then
				actor.damage(g.players[1],g.players[1].hp)
			end
			if not g.hud.menu then
				module.make(g.hud,EM.menu,EMM.text,g.camera.x,g.camera.y,200,200,"you won! ya got "..g.score.." coinz ! coinz are very valuable to ghost goodjob",EC.orange,EC.dark_green,"center")
			end
		end
	end,

	keypressed = function(g,key)
		if key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if g.starttimer==0 then
			g.countdown=true
		end
		if button=="start" then
			g.pause = not g.pause
			if #g.actors.persons<=1 then
				--level.make(g,1,Enums.modes.topdown_tank)
				game.state.make(g,"gameplay")
			end
		elseif button=="a" then
			--print(joystick:getID())
			if #g.actors.persons<=1 then
				--level.make(g,1,Enums.modes.topdown_tank)
				game.state.make(g,"gameplay")
--[[
			elseif #Joysticks>#g.players then
				local m=g.level.map
				--local a=actor.make(g,EA.person,g.level.map.width/2,g.level.map.height/2)
				--local a=actor.load(g,"person",20,20)
				local a=supper.random(g.actors.persons)
				player.make(g,a)
				--actor.make(g,EA.handgun,a.x,a.y)
--]]
			end			
		end
	end,

	draw = function(g)
		if g.countdown then
			local c=3
			if g.starttimer>=120 then
				c=1
			elseif g.starttimer>=60 then
				c=2
			end
			LG.print("COUNTDOWN..."..c,g.camera.x-40,g.camera.y)
		end
		if g.level.draw then
			local m=g.level.map
			local tw,th=m.tile.width,m.tile.height
			local v=166
--[[
			for y=1,m.h do
				local x=g.level.timer.cycles
				map.erasecellflags(m,x,y)
				map.setcellvalue(m,x,y,v)
				map.setcellflag(m,x,y,EF.kill)
				
				local cx,cy=(x-1)*tw,(y-1)*tw
				LG.setCanvas(g.level.canvas.background)
					LG.setBlendMode("replace")
					LG.setColor(g.palette[EC.pure_white])
					local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
					LG.translate(xcamoff,ycamoff)
						--LG.draw(Spritesheet[1],Quads[1][0],cx,cy)
						LG.draw(Spritesheet[1],Quads[1][v],cx,cy)
					LG.translate(-xcamoff,-ycamoff)
					LG.setBlendMode("alpha")
				LG.setCanvas(g.canvas.main)
			end
-]]
			for x=1,m.w do
				local y=g.level.timer.cycles
				map.erasecellflags(m,x,y)
				map.setcellvalue(m,x,y,v)
				map.setcellflag(m,x,y,EF.kill)

				local othersidey=m.h+1-y
				map.erasecellflags(m,x,othersidey)
				map.setcellvalue(m,x,othersidey,v)
				map.setcellflag(m,x,othersidey,EF.kill)

				local sidex=y
				local sidey=x
				local sideotherx=m.w+1-sidex
				if x<=m.h then
					map.erasecellflags(m,sidex,sidey)
					map.setcellvalue(m,sidex,sidey,v)
					map.setcellflag(m,sidex,sidey,EF.kill)

					map.erasecellflags(m,sideotherx,sidey)
					map.setcellvalue(m,sideotherx,sidey,v)
					map.setcellflag(m,sideotherx,sidey,EF.kill)
				end
				
				local cx,cy,cothery,csidex,csidey,csideotherx=(x-1)*tw,(y-1)*tw,(othersidey-1)*tw,(sidex-1)*tw,(sidey-1)*tw,(sideotherx-1)*tw
				LG.setCanvas(g.level.canvas.background)
					LG.setBlendMode("replace")
					LG.setColor(g.palette[EC.pure_white])
					local xcamoff,ycamoff=g.camera.x-g.width/2,g.camera.y-g.height/2
					LG.translate(xcamoff,ycamoff)
						LG.draw(Spritesheet[1],Quads[1][v],cx,cy)
						LG.draw(Spritesheet[1],Quads[1][v],cx,cothery)
						if x<=m.h then
							LG.draw(Spritesheet[1],Quads[1][v],csidex,csidey)
							LG.draw(Spritesheet[1],Quads[1][v],csideotherx,csidey)
						end
					LG.translate(-xcamoff,-ycamoff)
					LG.setBlendMode("alpha")
				LG.setCanvas(g.canvas.main)
			end
			g.level.draw=false
		end
	end
}

royalewe.title =
{
	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"gameplay")
		elseif key=='escape' then
			game.state.make(g,"intro")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"gameplay")
		elseif button=="b" then
			game.state.make(g,"intro")
		end
	end,

	draw = function(g)
		LG.printf("INSTRUCT ,",0,g.height/2-100,320,"center",0,1,1)

		LG.draw(Spritesheet[1],Quads[1][193],g.width/2-20,g.height/2-70,0,4,4)
		LG.printf("left stick move",0,g.height/2-40,320,"center",0,1,1)
		LG.printf("x or r trigger shoot",0,g.height/2-30,320,"center",0,1,1)
		LG.printf("a or l trigger aim",0,g.height/2-20,320,"center",0,1,1)
		LG.printf("coin: get",0,g.height/2-10,320,"center",0,1,1)

		LG.draw(Spritesheet[1],Quads[1][180],g.width/2-16,g.height/2+5,0,4,4)
		LG.printf("left stick move",0,g.height/2+40,320,"center",0,1,1)
		LG.printf("touch person to possess",0,g.height/2+50,320,"center",0,1,1)

		LG.printf("f full screen",0,g.height/2+80,320,"center",0,1,1)
		LG.printf("esc bye",0,g.height/2+90,320,"center",0,1,1)
		LG.printf("~ tab",0,g.height/2+100,320,"center",0,1,1)
	end
}

royalewe.intro =
{
	make = function(g)
		g.hud.font=LG.newFont("fonts/Kongtext Regular.ttf",20)
		
	end,

	keypressed = function(g,key)
		if key=="space" or key=="return" then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,joystick,button)
		if button=="start" or button=="a" then
			game.state.make(g,"title")
		end
	end,

	draw = function(g)
		LG.setFont(g.hud.font)
		LG.printf("THE",   0,g.height/2-30,320,"center",0,1,1,0,10,math.cos(g.timer/20))
		LG.printf("ROYALE",0,g.height/2,   320,"center",0,1,1,0,10,math.cos(g.timer/20))
		LG.printf("WE",    0,g.height/2+30,320,"center",0,1,1,0,10,math.cos(g.timer/20))
		LG.setFont(g.font)
		if math.floor(g.timer/40)%2==0 then
			LG.printf("press a or start",0,g.height/2+70,320,"center",0,1,1)
		end
	end
}

royalewe.actor = {}

royalewe.item =
{
	make = function(g,a)
		a.flags=flags.set(a.flags,EF.damageable)
		a.hp=1
	end,

	control = function(g,a,gs)
		local players=g.players
		for i,p in ipairs(players) do
			item.pickup(a,p)
		end
		local m=g.level.map
		local cx,cy=map.getcell(m,a.x,a.y)
		if flags.get(m[cy][cx],EF.kill,16) then
			actor.damage(a,a.hp)
		end
	end,

	carry = function(a,user)
		a.x=user.hand.x
		a.y=user.hand.y
		--a.angle=user.angle
	end,

	pickup = function(g,a,user)
		if actor.collision(a.x,a.y,user) then
			if a.held==false then
				if user.controller.action.action and #user.inventory<1 then
					if a.sound then
						if a.sound.get then
							sfx.play(a.sound.get)
						end
					end
					a.flags=flags.set(a.flags,EF.persistent)
					table.insert(user.inventory,1,a)
					a.held=true
					--print("hpendo")
					return true
				end
			end
		end
		return false
	end,
}

return royalewe