local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1
	module.make(m,EM.controller,EMC.move,EMI.gamepad)
	--module.make(m,EM.controller,EMC.select,EMC.selects.gamepad_menu_select)
end

local function control(m)
	controller.update(m)
	local c=m.controller.move
	local deadzone=0.25

	--TODO is this necessary? could maybe just put this in deadzone func
	local axes={"horizontal","vertical"}
	for i=1,#axes do
		if c[axes[i]]>0 and c[axes[i]]<deadzone then
			c[axes[i]]=0
		end

		if c[axes[i]]<0 and c[axes[i]]>-deadzone then
			c[axes[i]]=0
		end
	end

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

local function gamepadpressed(m,button)
	--controller.gamepadpressed(m,button)
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
	draw = draw,
}