local menu={}

menu.make = function(g,a,m,t,x,y,w,h,text,c1,c2,align,...)
	m.t=t
	-- maybe keep it basically this way
	-- if type(t)=="number" then
	-- 	m.t=t
	-- else 
	-- 	m.t=EMM[t]
	-- end
	m.x=math.floor(x)
	m.y=math.floor(y)
	m.w=w
	m.h=h
	m.text=text--this can be a table or string
	m.c1=c1
	m.c2=c2
	m.align=align or "left"
	--m.font=LG.newFont("fonts/Kongtext Regular.ttf",8)--TODO make fonts an array in game, then menu can select from them
	m.font=LG.newFont("fonts/Kongtext Regular.ttf",8)--TODO make fonts an array in game, then menu can select from them

	run(m.t,"make",g,m,...)
end

menu.control = function(g,m,gs)
	run(m.t,"control",g,m,gs)
	if m.transition then
		transition.control(m,m.transition)
	end
end

menu.keypressed = function(g,m,key)
	run(m.t,"keypressed",g,m,key)
end

menu.keyreleased = function(g,m,key)
	run(m.t,"keyreleased",g,m,key)
end

menu.gamepadpressed = function(m,button)
	run(m.t,"gamepadpressed",m,button)
end

menu.draw = function(g,m)
	if m.border then
		border.draw(m,m.border)
	end
	LG.setFont(m.font)
	if not run(m.t,"draw",g,m) then
		run("text","draw",g,m)
	end
	LG.setFont(g.font)
---[[
	if Debugger.debugging then
		LG.setColor(g.palette["red"])
		LG.points(m.x,m.y)
	end
--]]
end

return menu