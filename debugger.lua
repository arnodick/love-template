local function update()
	local debuglist={}
	table.insert(debuglist,Timer)
	--table.insert(debuglist,"mem="..stat(0))--TODO: figure out what FPS and CPU is
	--table.insert(debuglist,"cpu="..stat(1))
	table.insert(debuglist,"FPS:"..love.timer.getFPS( ))
	table.insert(debuglist,"Actors:"..#Actors)
	table.insert(debuglist,"camx:"..Camera.x)--TODO: figure out camera
	table.insert(debuglist,"camy:"..Camera.y)
	return debuglist
end

local function draw(debuglist)
	love.graphics.setFont(FontDebug)
	love.graphics.setColor(200, 0, 0, 255)
	love.graphics.print("DEBUG",130,0)
	for i,v in ipairs(debuglist) do
		love.graphics.print(v,10,10+FontDebug:getHeight()*i)
	end
	love.graphics.setColor(255, 255, 255, 255) --sets draw colour back to normal
	love.graphics.setFont(Font)
end

return
{
	update = update,
	draw = draw,
}