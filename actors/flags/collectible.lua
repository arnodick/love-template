local function control(a,gs)
	if not flags.get(a.flags,EF.shopitem) then
		if not a.spr then
			a.spr=a.sprinit
		end
		if actor.collision(a.x,a.y,Player) then
			if Player[EA.collectibles[a.st]] then
				Player[EA.collectibles[a.st]] = Player[EA.collectibles[a.st]] + a.value
			end
			for i,v in pairs(Game.actors) do
				if v.t==EA.collectible then
					if v.st==EA.collectibles.coin then
						v.scalex=4
						v.scaley=4
						v.deltimer=0
						v.delta=Game.timer
					end
				end
			end
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			actor.make(EA.collectibleget,a.x,a.y,math.pi/2,1,EC.pure_white,1,a.sprinit)
			if _G[EA.collectibles[a.st]]["get"] then
				_G[EA.collectibles[a.st]]["get"](a,gs)
			end
			a.delete=true
		end
	else

	end
	if _G[EA.collectibles[a.st]]["control"] then
		_G[EA.collectibles[a.st]]["control"](a,gs)
	end
end

return
{
	control = control,
}