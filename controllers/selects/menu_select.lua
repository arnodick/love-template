local function gamepadpressed(m,c,button)
	if button=='start' or button=='a' then
		local i=m.text.index
		if m.menu_functions[i] then
			m.menu_functions[i](unpack(m.menu_function_args[i]))
		end
	end
end

return
{
	gamepadpressed = gamepadpressed,
}