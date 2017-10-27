local protosnake={}

protosnake.make = function(g,tw,th,gw,gh,sp)
	level.load(g,"games/levels/protosnake/inis")
	g.levelpath={}
end

protosnake.gameplay =
{
	make = function(g)
		module.make(g.state,EM.hud,EM.huds.protosnake_hud)

		g.score=0

		local mw,mh=g.width/g.tile.width,g.height/g.tile.height
		g.map=map.generate("walls",mw+2,mh+2)

		g.player=actor.make(EA[Game.name].player,g.width/2,g.height/2)
		--module.make(a,EM.player)

		g.level=1
		level.make(g,g.level)
	end,

	control = function(g)
		local s=g.state

		if Game.player.hp<=0 then
			if not s.hud.menu then
				module.make(s.hud,EM.menu,EMM.highscores,g.width/2,g.height/2,66,100,"",s.hud.c,s.hud.c2,"center")
			end
		end
	end,

	keypressed = function(g,key)
		if key=='space' then
			if Game.player.hp<=0 then
				game.state.make(g,"gameplay",Enums.games.modes.topdown)
			end
		elseif key=='escape' then
			game.state.make(g,"title")
		end
	end,

	gamepadpressed = function(g,button)
		if button=="start" then
			if Game.player.hp<=0 then
				game.state.make(g,"gameplay",Enums.games.modes.topdown)
			else
				g.pause = not g.pause
			end
		end
	end
}

protosnake.title =
{
	make = function(g)
		g.state.font=LG.newFont("fonts/Kongtext Regular.ttf",64)
		g.scores=scores.load()
		music.play(1)
		module.make(g.state,EM.menu,EMM.interactive,Game.width/2,180,60,30,{"START","OPTIONS"},EC.orange,EC.dark_green,"left",{game.state.make,game.state.make},{{Game,"gameplay",Enums.games.modes.topdown},{Game,"option"}})
		--EC.indigo,EC.dark_purple
	end,

	control = function(g)
		menu.control(g.state.menu)
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
		local m=g.state.menu
		if m then
			menu.gamepadpressed(m,button)
		end
	end,

	draw = function(g)
		local s=g.state
		LG.setCanvas(g.canvas.buffer)
			LG.setFont(s.font)
			LG.setColor(g.palette[EC.dark_purple])
			LG.printf("PROTO\nSNAKE",0,20,Game.width,"center")
			LG.setFont(Game.font)
			LG.setColor(g.palette[EC.white])
			menu.draw(g.state.menu)
			--LG.printf("PRESS SPACE",0,180,Game.width,"center")
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
		g.state.imgdata=love.image.newImageData(g.canvas.buffer:getWidth()-1,g.canvas.buffer:getHeight()-1)
		g.state.font=LG.newFont("fonts/Kongtext Regular.ttf",20)
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
		local s=g.state
		LG.setCanvas(g.canvas.buffer)
			LG.clear()
			LG.setFont(s.font)
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
				local r,g,b,a = imgdata:getPixel(x,y)
				s.imgdata:setPixel(xsquish,y,r,g,b,a)
		    end
		end
		local image=LG.newImage(s.imgdata)
		love.graphics.draw(image,g.width/2,g.height/2,math.sin(g.timer/100)/3,1,1,g.width/2,g.height/2,0,0)
	end,
}

protosnake.option =
{
	make = function(g)
		music.play(1)
	end,

	control = function(g)

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

return protosnake