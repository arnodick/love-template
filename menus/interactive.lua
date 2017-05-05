local function make(m,buttons,args)
	m.buttons=buttons
	m.args=args
	m.text.index=1
	--controller.make(m,ECT.move,ECT.moves.gamepad_move)
	controller.make(m,ECT.move,ECT.moves.gamepad_menu)
end

local function control(m)
	controller.update(m)
end

local function gamepadpressed(m,button)
	if button=='start' or button=='a' then
		local i=m.text.index
		if m.buttons[i] then
			m.buttons[i](unpack(m.args[i]))
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