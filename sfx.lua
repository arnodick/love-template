local sfx={}

--TODO how to handle positional?
sfx.load = function(positional)
	local s=library.load("sfx","wav","ogg")
	s.positional=positional or false
	return s
end

sfx.play = function(index,x,y)
	local g=Game
	if not SFX.positional then
		local source=SFX[index].source
		if source then
			love.audio.stop(source)
			local pitch=math.clamp(g.speed,0.2,1)
			SFX[index].pitchoffs=math.randomfraction(0.2)-0.1
			source:setPitch(pitch+SFX[index].pitchoffs)
			love.audio.play(source)
		end
	else
		--TODO seems like we can just do this in library.load instead?
		local source=SFX[index].source
		if source then
			source=love.audio.newSource(source,"static")--DON'T want to be calling this a lot https://love2d.org/wiki/love.audio.newSource
			local play=false
			if vector.distance(x,y,g.camera.x,g.camera.y)<320 then
				play=true
				source:setRelative(false)
				source:setPosition(x,y,0)
				source:setRolloff(0.2)
			end
			if play then
				local pitch=math.clamp(g.speed,0.2,1)+math.randomfraction(0.2)-0.1
				source:setPitch(pitch)
				love.audio.play(source)
			end
		end
	end
end

sfx.control = function(s,gs)
	if not s.positional then
		for i,v in ipairs(s) do
			local pitch=math.clamp(gs,0.2,1)
			v.source:setPitch(pitch+s[i].pitchoffs)
		end
	end
end

return sfx