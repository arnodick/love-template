local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1
	module.make(m,EM.controller,EMC.move,EMCI.keyboard)
	--module.make(m,EM.controller,EMC.select,EMC.selects.gamepad_menu_select)
end

local function control(m)
	controller.update(m)
	local c=m.controller.move

	if c.vertical<0 then
		if c.last.vertical>=0 then
			m.text.index=math.clamp(m.text.index-1,1,#m.text,true)
		end
	elseif c.vertical>0 then
		if c.last.vertical<=0 then
			m.text.index=math.clamp(m.text.index+1,1,#m.text,true)
		end
	end
end

local function keypressed(m,key)
	if key=='z' then
		local i=m.text.index
		if m.menu_functions[i] then
			m.menu_functions[i](unpack(m.menu_function_args[i]))
		end
	end
end

local function gamepadpressed(m,button)
	if button=='start' or button=='a' then
		local i=m.text.index
		if m.menu_functions[i] then
			m.menu_functions[i](unpack(m.menu_function_args[i]))
		end
	end
end

local function draw(m)
end

return
{
	make = make,
	control = control,
	gamepadpressed = gamepadpressed,
	keypressed = keypressed,
	draw = draw,
}