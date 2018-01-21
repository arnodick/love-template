local editor={}

editor.make = function(g)
	g.editor={}
	--module.make(g.editor,EM.cursor,EM.cursors.cursor_editor,true)
	module.make(g.editor,EM.cursor,"editor",true)
end

editor.control = function(g)
	cursor.update(g.editor.cursor)
end

editor.mousepressed = function(g,x,y,button)
	cursor.mousepressed(g,g.editor.cursor,x,y,button)
--[[
	if button==1 then
		map.setcellvalue(g.level.map,g.editor.cursor.x,g.editor.cursor.y,g.editor.cursor.value,true)
	elseif button==2 then
		map.setcellflag(g.level.map,g.editor.cursor.x,g.editor.cursor.y,EF.solid,true)
	end
--]]
end

editor.wheelmoved = function(g,x,y)
	if love.keyboard.isDown('lctrl') then
		g.camera.zoom=g.camera.zoom+y
	else
		g.editor.cursor.value=math.clamp(g.editor.cursor.value+y,0,255)--TODO make this limit more dynamic?
		--g.editor.cursor.value=g.editor.cursor.value+y
	end
end

editor.draw = function(g)
	LG.printformat("EDITOR",g.camera.x-g.width/2,g.camera.y-15,g.width,"center",EC.red,EC.blue)
	cursor.draw(g.editor.cursor)
end

return editor