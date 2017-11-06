local editor={}

editor.make = function(g)
	g.editor={}
	module.make(g.editor,EM.cursor,EM.cursors.cursor_editor,true)
end

editor.control = function(g)
	cursor.update(g.editor.cursor)
end

editor.mousepressed = function(g,x,y,button)
	if button==1 then
		cx,cy=map.getcell(g.level.map,g.editor.cursor.x,g.editor.cursor.y)
		g.level.map[cy][cx]=g.editor.cursor.value
	end
end

editor.wheelmoved = function(g,x,y)
	if love.keyboard.isDown('lctrl') then
		g.camera.zoom=g.camera.zoom+y
	else
		g.editor.cursor.value=math.clamp(g.editor.cursor.value+y,0,272)--TODO why is this 272? must be a bug in quad generation
		--g.editor.cursor.value=g.editor.cursor.value+y
	end
end

editor.draw = function(g)
	LG.printformat("EDITOR",g.camera.x-g.width/2,g.camera.y-15,g.width,"center",EC.red,EC.blue)
	cursor.draw(g.editor.cursor)
end

return editor