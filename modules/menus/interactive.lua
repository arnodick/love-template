local interactive={}

interactive.make = function(g,m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1

	controller.assign(g,m,g.options,{inputtype="digital"})
end

interactive.control = function(g,m,gs)
	controller.update(m,gs)
	local c=m.controller.move

	--TODO move this into
	if c.vertical<0 then
		if c.last.vertical>=0 or (c.duration.vertical>30 and math.floor(g.timer)%4==0) then
			m.text.index=math.clamp(m.text.index-1,1,#m.text,true)
		end
	elseif c.vertical>0 then
		if c.last.vertical<=0 or (c.duration.vertical>30 and math.floor(g.timer)%4==0) then
			m.text.index=math.clamp(m.text.index+1,1,#m.text,true)
		end
	end
end

interactive.keypressed = function(g,m,key)
	if key=='z' then
		local i=m.text.index
		if m.menu_functions[i] then
			m.menu_functions[i](unpack(m.menu_function_args[i]))
		end
	end
end

interactive.gamepadpressed = function(m,button)
	if not m.controller.action.lastuse then
		if button=='start' or button=='a' then
			local i=m.text.index
			if m.menu_functions[i] then
				m.menu_functions[i](unpack(m.menu_function_args[i]))
			end
		end
	end
end

--[[
local function draw(m)
end
--]]

return interactive