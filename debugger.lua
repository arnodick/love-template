local function update()
	local debuglist={}
	table.insert(debuglist,Timer)
	table.insert(debuglist,Game.speed)
	table.insert(debuglist,"FPS:"..love.timer.getFPS())
	table.insert(debuglist,"Actors:"..#Actors)
	table.insert(debuglist,"player x:"..Player.x)
	table.insert(debuglist,"player y:"..Player.y)
	table.insert(debuglist,"player dir:"..Player.d)
	table.insert(debuglist,"player vx:"..Player.vec[1])
	table.insert(debuglist,"player vy:"..Player.vec[2])
	table.insert(debuglist,"player vel:"..Player.vel)
	table.insert(debuglist,"camx:"..Camera.x)
	table.insert(debuglist,"camy:"..Camera.y)
	if Actors[2] then
	table.insert(debuglist,Actors[2].x)
	table.insert(debuglist,Actors[2].y)
	end
---[[
	local axes={Joystick:getAxes()}
	table.insert(debuglist,"joy axes:"..#axes)
	for i=1,#axes do
		table.insert(debuglist,"axis"..i..":"..axes[i])
	end
--]]

	return debuglist
end

local function draw(debuglist)
	love.graphics.setFont(FontDebug)
	love.graphics.setColor(Palette[11])
	love.graphics.print("DEBUG",130,0)
	for i,v in ipairs(debuglist) do
		love.graphics.print(v,10,10+FontDebug:getHeight()*i)
	end
	love.graphics.setColor(Palette[16]) --sets draw colour back to normal
	love.graphics.setFont(Font)
end

return
{
	update = update,
	draw = draw,
}