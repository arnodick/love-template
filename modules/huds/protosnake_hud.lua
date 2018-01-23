--TODO put all this AWAY baby woo
--cann all go in game-specific file ie bighands.lua has protosnake.hud.make = function blah
local function make(h)
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
end

local function draw(g,h)
	LG.setColor(g.palette[h.c])

	LG.print("score:"..g.score,g.camera.x+h.score.x,g.camera.y+h.score.y)
	LG.print("coins:"..Game.player.coin,g.camera.x+h.coins.x,g.camera.y+h.coins.y)
	LG.print("hp:"..Game.player.hp,g.camera.x+h.hp.x,g.camera.y+h.hp.y)

	for i=1,Game.player.inventory.max do
		local x,y=g.camera.x+40-i*20,20
		LG.rectangle("line",x,y,15,15)
		if Game.player.inventory[i] then
			local a=Game.player.inventory[i]
			LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*g.tile.width)/2,(a.size*g.tile.height)/2)
		end
	end

	if g.pause then
		LG.printformat("PAUSE",g.camera.x-g.width/2,g.camera.y,g.width,"center",EC.white,h.c)
	end

	if Game.player.hp <= 0 then
		LG.printformat("YOU DIED",g.camera.x-g.width/2,g.camera.y-66,g.width,"center",EC.white,h.c)
		LG.printformat("PRESS SPACE",g.camera.x-g.width/2,g.camera.y+60,g.width,"center",EC.white,h.c)
	end
	LG.setColor(g.palette[EC.pure_white])
	LG.print(love.timer.getFPS(),10,10)
end

return
{
	make = make,
	draw = draw,
}