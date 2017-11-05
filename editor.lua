local editor={}

editor.make = function(g)
	g.editor={}
	module.make(g.editor,EM.cursor,EM.cursors.cursor_editor,true)
end

editor.control = function(g)
	cursor.update(g.editor.cursor)
end

editor.draw = function(g)
	LG.printformat("EDITOR",g.camera.x-g.width/2,g.camera.y-15,g.width,"center",EC.red,EC.blue)
	cursor.draw(g.editor.cursor)
end

return editor
--[[

local function mousepressed(g,x,y,button)
	if button==1 then
		cx,cy=map.getcell(g.map,g.state.cursor.x,g.state.cursor.y)
		g.map[cy][cx]=g.state.cursor.value
	end
	if _G[Enums.games.states.editors[g.state.st] ]["mousepressed"] then
		_G[Enums.games.states.editors[g.state.st] ]["mousepressed"](g,x,y,button)
	end
end

local function wheelmoved(g,x,y)
	if love.keyboard.isDown('lctrl') then
		g.camera.zoom=g.camera.zoom+y
	else
		g.state.cursor.value=g.state.cursor.value+y
	end
end

local function draw(g)
	map.draw(g.map)
end

--]]