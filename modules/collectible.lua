local function control(a,gs)
	if not flags.get(a.flags,EF.shopitem) then
		if actor.collision(a.x,a.y,Game.player) then
			if Game.player[EA[Game.name][a.t]] then
				Game.player[EA[Game.name][a.t]] = Game.player[EA[Game.name][a.t]] + a.value
			end
			for i,v in pairs(Game.actors) do
				if v.t==EA[Game.name].coin then
					v.scalex=4
					v.scaley=4
					v.deltimer=0
					v.delta=Game.timer
				end
			end
			if a.getsfx then
				sfx.play(a.getsfx)--TODO make get sfx or just sfx a module
			end
			actor.make(EA[Game.name].collectibleget,a.x,a.y,math.pi/2,1,EC.pure_white,1,a.sprinit)
			if _G[EA[Game.name][a.t]]["get"] then
				_G[EA[Game.name][a.t]]["get"](a,gs)
			end
			a.delete=true
		end
	end
end

return
{
	control = control,
}