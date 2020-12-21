local item={}

item.make = function(g,a)
	a.angle=-0.79--TODO put this in actor.make
	a.delta=0--NOTE need this bc actor.make sets delta to g.timer, so any actor not spawning at g.timer==0 can't shoot
	a.held=false
	
	module.make(g,a,EM.sound,10,"get")

	if not g.actors.items then
		g.actors.items={}
	end
	table.insert(g.actors.items,a)
	game.state.run(g.name,"item","make",g,a)
	return a
end

item.control = function(g,a,gs)
	game.state.run(g.name,"item","control",g,a,gs)
end

item.carry = function(g,a,user)
	game.state.run(g.name,"item","carry",g,a,user)
end

--TODO get rid of shoot stuff, make it "using" or something?
item.use = function(g,a,gs,user,vx,vy,shoot)
	a.angle=vector.direction(vx,vy)
	a.vec[1]=math.cos(a.angle)
	a.vec[2]=math.sin(a.angle)

	if a.delta<=0 then
		if shoot then
			sfx.play(g,a.snd,a.x,a.y)
			run(EA[a.t],"shoot",g,a,gs)
			a.delta=a.rof
		end
	else 
		a.delta=a.delta-1*gs
	end
end

item.pickup = function(g,a,user)
	return game.state.run(g.name,"item","pickup",g,a,user)
end

item.drop = function(g,a,user)
	game.state.run(g.name,"item","drop",g,a,user)
end

return item