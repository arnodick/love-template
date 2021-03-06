local spacetank9001={}

spacetank9001.make = function(g)
	---[[
	g.window={}
    -- g.window.width=192
    -- g.window.height=128
	g.window.width=768
    g.window.height=512
	--]]
end

spacetank9001.level={}

spacetank9001.level.make = function(g,l,index)

end

spacetank9001.level.control = function(g,l)

end

spacetank9001.player={}
spacetank9001.player.make = function(g,a)
end
spacetank9001.player.control = function(g,a)
end
spacetank9001.player.draw = function(g,a)
	--TODO put this in actor
	if a.cursor then
		cursor.draw(g,a.cursor)
	end
end
spacetank9001.player.damage = function(g,a)--TODO input g here
end
spacetank9001.player.dead = function(g,a)
end

spacetank9001.gameplay={}
spacetank9001.gameplay.make = function(g)
end
spacetank9001.gameplay.control = function(g)
end
spacetank9001.gameplay.keypressed = function(g,key)
end
spacetank9001.gameplay.mousemoved = function(g,x,y,dx,dy)
end
spacetank9001.gameplay.gamepadpressed = function(g,joystick,button)
end
spacetank9001.gameplay.hud={}
spacetank9001.gameplay.hud.make = function(g,h)
end
spacetank9001.gameplay.hud.draw = function(g,h)
end

spacetank9001.title={}
spacetank9001.title.make = function(g)
end
spacetank9001.title.control = function(g)
end
spacetank9001.title.keypressed = function(g,key)
end
spacetank9001.title.gamepadpressed = function(g,joystick,button)
end
spacetank9001.title.draw = function(g)
end

spacetank9001.intro={}
spacetank9001.intro.make = function(g)
	g.intro={}
	g.intro.x=0
	g.intro.y=120
	g.intro.st=255
	g.intro.td={16,40,50,60}
	g.intro.col={1,2,2,2}
	g.intro.text=json.load("games/spacetank9001/intro_text.json")
	music.play(5)
end
spacetank9001.intro.control = function(g)
	if g.timer>=1140 then
		sfx.play(g,2)
		game.state.make(g,"title")
	end
end
spacetank9001.intro.keypressed = function(g,key)
	if game.keyconfirm(key) then
		sfx.play(g,2)
		game.state.make(g,"title")
	end
end
spacetank9001.intro.gamepadpressed = function(g,joystick,button)
end
spacetank9001.intro.draw = function(g)
	local ind=0
	for a=0,2 do
		if g.timer>g.intro.st*2^a then ind=a+1 end
	end
	for a=1,#g.intro.text do
		-- print(math.floor(7+((g.timer/2+(a-1)*10)/g.intro.td[ind+1])%g.intro.col[ind+1]))
		local num=math.floor(7+((g.timer/2+(a-1)*10)/g.intro.td[ind+1])%g.intro.col[ind+1])
		love.graphics.setColor(g.palette[g.palette[num]])
		-- love.graphics.setColor(g.palette["red"])
		love.graphics.print(g.intro.text[a],g.intro.x,math.floor(g.intro.y+a*7-g.timer/4))
		-- love.graphics.print(g.intro.text,g.intro.x,math.floor(g.intro.y+a*7-g.timer/4))
	end
end

spacetank9001.option={}
spacetank9001.option.make = function(g)
end
spacetank9001.option.keypressed = function(g,key)
end
spacetank9001.option.gamepadpressed = function(g,joystick,button)
end
spacetank9001.option.draw = function(g)
end

spacetank9001.actor={}
spacetank9001.actor.damage = function(g,a,d)
end
spacetank9001.actor.dead = function(g,a)
end

spacetank9001.item={}
spacetank9001.item.control = function(g,a,gs)
end
spacetank9001.item.carry = function(g,a,user)
end
spacetank9001.item.pickup = function(g,a,user)
end
spacetank9001.item.drop = function(g,a,user)
end

spacetank9001.collectible={}
spacetank9001.collectible.control = function(g,a,gs)
end

return spacetank9001