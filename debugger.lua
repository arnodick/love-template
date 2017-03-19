local function update()
	local debuglist={}
	table.insert(debuglist,Timer)
	table.insert(debuglist,Game.speed)
	table.insert(debuglist,"FPS:"..love.timer.getFPS())
	table.insert(debuglist,"Actors:"..#Actors)
	table.insert(debuglist,"Level:"..Game.settings.level)
	table.insert(debuglist,"player x:"..Player.x)
	table.insert(debuglist,"player y:"..Player.y)
	local xc,yc=map.getcell(Game.settings.map,Player.x,Player.y)
	table.insert(debuglist,"player x cell:"..xc)
	table.insert(debuglist,"player y cell:"..yc)
	table.insert(debuglist,"player dir:"..Player.d)
	table.insert(debuglist,"player vx:"..Player.vec[1])
	table.insert(debuglist,"player vy:"..Player.vec[2])
	table.insert(debuglist,"player vel:"..Player.vel)
	if Player.inv[1] then
	table.insert(debuglist,"player item angle:"..Player.inv[1].angle)
	end
	table.insert(debuglist,"camx:"..Camera.x)
	table.insert(debuglist,"camy:"..Camera.y)
	table.insert(debuglist,"pause: "..tostring(Game.pause))
--[[
	if #Joysticks>0 then
		local axes={Joysticks[1]:getAxes()}
		table.insert(debuglist,"joy axes:"..#axes)
		for i=1,#axes do
			table.insert(debuglist,"axis"..i..":"..axes[i])
		end
	end
--]]
	return debuglist
end

local function draw(debuglist)
	if DebugMode then
		LG.setCanvas(Canvas.debug) --sets drawing to the 1280 x 960 debug canvas
		LG.clear() --cleans that messy ol canvas all up, makes it all fresh and new and good you know

		LG.setFont(FontDebug)
		LG.setColor(Palette[11])
		LG.print("DEBUG",130,0)
		for i,v in ipairs(debuglist) do
			LG.print(v,10,10+FontDebug:getHeight()*i)
		end
		LG.setColor(Palette[16]) --sets draw colour back to normal
		LG.setFont(Font)

		LG.setCanvas() --sets drawing back to screen
		LG.origin()
		LG.draw(Canvas.debug,0,0,0,1,1) --just like draws everything to the screen or whatever
	end
end

local function printtable(table,space)
	space=space or ""
	for i,v in pairs(table) do
		print(space..i.." = "..tostring(v))
		if type(v)=="table" then
			printtable(v,space.." ")
		end
	end
end

return
{
	update = update,
	draw = draw,
	printtable = printtable,
}