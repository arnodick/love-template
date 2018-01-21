local editor={}

editor.make = function(g)
	g.editor={}
	module.make(g.editor,EM.cursor,"editor",true)
end

editor.control = function(g)
	cursor.update(g.editor.cursor)
end

editor.keypressed = function(g,key)
	if love.keyboard.isDown('lctrl') then
		if key=="s" then
			map.save(g.level.map,"maptest.txt")
		end
	end
end

editor.mousepressed = function(g,x,y,button)
	cursor.mousepressed(g,g.editor.cursor,x,y,button)
end

editor.wheelmoved = function(g,x,y)
	if love.keyboard.isDown('lctrl') then
		g.camera.zoom=g.camera.zoom+y
	else
		cursor.wheelmoved(g,g.editor.cursor,x,y)
	end
end

editor.draw = function(g)
	LG.printformat("EDITOR",g.camera.x-g.width/2,g.camera.y-15,g.width,"center",EC.red,EC.blue)
	cursor.draw(g.editor.cursor)
end

return editor