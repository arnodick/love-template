local function gamepadpressed(a,i,button)
	if _G[EMI.selects[i.st]]["gamepadpressed"] then
		_G[EMI.selects[i.st]]["gamepadpressed"](a,i,button)
	end
end

return
{
	gamepadpressed = gamepadpressed,
}