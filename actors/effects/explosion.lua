local function make(a,size)
	sfx.play(1,a.x,a.y)
	a.r=0
	a.size=size or 20
	a.flags=actor.setflags(a.flags, Enums.flags.gravity,Enums.flags.ground_delta)
	Camera.shake=a.size
end

local function control(a,gs)
	local delta = (Timer-a.delta)
	a.r = a.size*(delta/6)
	if a.r>=a.size then
		for j=1,6*a.size do
			local s = math.randomfraction(a.size/2)
			local dir = math.randomfraction(math.pi*2)
			local d = math.randomfraction(math.pi*2)
			actor.make(Enums.actors.effect,Enums.effects.cloud,a.x+math.cos(dir)*s,a.y+math.sin(dir)*s,Enums.colours.dark_gray,d,math.randomfraction(0.5),6)
		end
--[[
		for i,t in ipairs(Actors) do
			--TODO make Effects a type, put if a.t==Enums.actortypes.effect here
			local dist = math.abs(vector.distance(t.x,t.y,a.x,a.y))
			if dist<1 then dist=1 end
			if dist<a.r then
				if t.t==Enums.actors.effect then
					local vecx,vecy=vector.components(a.x,a.y,t.x,t.y)
					t.d,t.vel = actor.impulse( t,vector.direction(vecx,vecy),(a.r/(dist*2)),true )
				end
				if actor.getflag(t.flags,Enums.flags.explodable) then
					actor.damage(t,1)
				end
			end
		end
--]]
		a.delete=true
	end
end

local function draw(a)
	love.graphics.circle("fill",a.x,a.y,a.r,16)
	if DebugMode then
		love.graphics.setColor(Palette[11])
		love.graphics.circle("line",a.x,a.y,a.r)
	end
end

return
{
	make = make,
	control = control,
	draw = draw,
}