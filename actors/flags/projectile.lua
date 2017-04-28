local function make(a,c,...)
	a.cinit=c or EC.red
	a.c=a.cinit
	if _G[EA.projectiles[a.st]]["make"] then
		_G[EA.projectiles[a.st]]["make"](a,...)
	end
end

local function predraw(a)
	if _G[EA.projectiles[a.st]]["predraw"] then
		_G[EA.projectiles[a.st]]["predraw"](a)
	end
end

local function collision(a)
	if _G[EA.projectiles[a.st]]["collision"] then
		_G[EA.projectiles[a.st]]["collision"](a)
	end
end

return
{
	make = make,
	predraw = predraw,
	collision = collision,
}