local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1
	module.make(m,EM.controller,EMC.move,EMC.moves.gamepad_menu_move)
	module.make(m,EM.controller,EMC.select,EMC.selects.gamepad_menu_select)
end

local function control(m)
	controller.update(m)
end

local function gamepadpressed(m,button)
	controller.gamepadpressed(m,button)
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