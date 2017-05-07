local function gamepadpressed(a,c,button)
	if _G[ECT.selects[c.st]]["gamepadpressed"] then
		_G[ECT.selects[c.st]]["gamepadpressed"](a,c,button)
	end
end

return
{
	gamepadpressed = gamepadpressed,
}