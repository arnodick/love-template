local function gamepadpressed(a,c,button)
	if _G[EMC.selects[c.st]]["gamepadpressed"] then
		_G[EMC.selects[c.st]]["gamepadpressed"](a,c,button)
	end
end

return
{
	gamepadpressed = gamepadpressed,
}