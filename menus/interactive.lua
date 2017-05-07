local function make(m,menu_functions,menu_function_args)
	m.menu_functions=menu_functions
	m.menu_function_args=menu_function_args
	m.text.index=1
	--controller.make(m,ECT.move,ECT.moves.gamepad_move)
	controller.make(m,ECT.move,ECT.moves.gamepad_menu)
	controller.make(m,ECT.select,ECT.selects.menu_select)
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