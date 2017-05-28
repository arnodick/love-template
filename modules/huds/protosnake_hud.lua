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

local function draw(h)
	LG.setColor(Game.palette[h.c+1])
	LG.print("score:"..Game.score,Game.camera.x+h.score.x,Game.camera.y+h.score.y)
	LG.print("coins:"..Player.coin,Game.camera.x+h.coins.x,Game.camera.y+h.coins.y)
	LG.print("hp:"..Player.hp,Game.camera.x+h.hp.x,Game.camera.y+h.hp.y)
	for i=1,Player.inventory.max do
		local x,y=Game.width/2+40-i*20,20
		LG.rectangle("line",x,y,15,15)
		if Player.inventory[i] then
			local a=Player.inventory[i]
			LG.draw(Spritesheet[a.size],Quads[a.size][a.spr],x+7,y+7,a.angle,1,1,(a.size*Game.tile.width)/2,(a.size*Game.tile.height)/2)
		end
	end
end

return
{
	make = make,
	draw = draw,
}