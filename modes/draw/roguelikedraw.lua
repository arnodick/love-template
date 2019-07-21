local roguelikedraw={}

roguelikedraw.draw = function(g,a)
	if a.char then
		print("true")
		local m=g.level.map
		LG.setColor(100,200,100)--TODO
		LG.print(a.char,(a.x-1)*m.tile.width,(a.y-1)*m.tile.height)
	end
end

return roguelikedraw