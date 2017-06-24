local function gamepadpressed(m,i,button)
	if button=='start' or button=='a' then
		local index=m.text.index
		if m.menu_functions[index] then
			m.menu_functions[index](unpack(m.menu_function_args[index]))
		end
	end
end

return
{
	gamepadpressed = gamepadpressed,
}