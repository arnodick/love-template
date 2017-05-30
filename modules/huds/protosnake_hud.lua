local function make(h)
	h.c=EC.orange
	h.c2=EC.dark_green
	h.score={}
	h.score.x=12
	h.score.y=6
	h.coins={}
	h.coins.x=120
	h.coins.y=6
	h.hp={}
	h.hp.x=240
	h.hp.y=6
end

local function draw(g,h)
	LG.setColor(g.palette[h.c])

	LG.print("score:"..g.score,g.camera.x+h.score.x,g.camera.y+h.score.y)
	LG.print("coins:"..Player.coin,g.camera.x+h.coins.x,g.camera.y+h.coins.y)
	LG.print("hp:"..Player.hp,g.camera.x+h.hp.x,g.camera.y+h.hp.y)

	for i=1,Player.inventory.max do
		local x,y=g.width/2+40-i*20,20
		LG.rectangle("line",x,y,15,15)
		if Player.inventory[i] then
			local a=Player.inventory[i]
			LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*g.tile.width)/2,(a.size*g.tile.height)/2)
		end
	end

	if g.pause then
		LG.printformat("PAUSE",g.camera.x+140,g.camera.y+g.height/2,g.width,"left",EC.white,h.c)
	end

	if Player.hp <= 0 then
		LG.printformat("YOU DIED",0,g.height/2-66,g.width,"center",EC.white,h.c)
		LG.printformat("PRESS SPACE",0,g.height/2+60,g.width,"center",EC.white,h.c)
	end

	LG.setColor(g.palette[EC.pure_white])
end

return
{
	make = make,
	draw = draw,
}