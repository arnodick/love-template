local animation={}

--TODO what is going on here?
animation.make = function(g,a,m,t,...)
	m[EM.animations[t]]={}
	run(EM.animations[t],"make",m[EM.animations[t]],...)
end

--TODO clean this up, use run?
animation.draw = function(g,animname,anim)
	if _G[animname]["draw"] then
		return _G[animname]["draw"](g,anim)
	end
end

return animation