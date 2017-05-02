local function control(a,gs)
	if not flags.get(a.flags,EF.shopitem) then
		if not a.spr then
			a.spr=a.sprinit
		end
		if actor.collision(a.x,a.y,Player) then
			if Player[EA[a.t]] then
				Player[EA[a.t]] = Player[EA[a.t]] + a.value
			end
			for i,v in pairs(Game.actors) do
				if v.t==EA.coin then
					v.scalex=4
					v.scaley=4
					v.deltimer=0
					v.delta=Game.timer
				end
			end
			if a.getsfx then
				sfx.play(a.getsfx)
			end
			actor.make(EA.collectibleget,a.x,a.y,math.pi/2,1,EC.pure_white,1,a.sprinit)
			if _G[EA[a.t]]["get"] then
				_G[EA[a.t]]["get"](a,gs)
			end
			a.delete=true
		end
	end
	if _G[EA[a.t]]["control"] then
		_G[EA[a.t]]["control"](a,gs)
	end
end

return
{
	control = control,
}