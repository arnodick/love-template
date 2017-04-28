local function collision(a)
	if _G[EA.effects[a.st]]["collision"] then
		_G[EA.effects[a.st]]["collision"](a)
	end
end

return
{
	collision = collision,
}