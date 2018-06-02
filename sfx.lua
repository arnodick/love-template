local sfx={}

sfx.load = function(positional)
	local s={}
	s.sources={}
	s.pitchoffs={}
	s.positional=positional or false
	local files=love.filesystem.getDirectoryItems("sfx") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("sfx/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local ext = filedata:getExtension()
			if ext=="ogg" or ext=="wav" then --if it's a .ogg, add to SFX (maybe make this flexible for other sound files ie mp3)
				if positional then
					table.insert(s.sources,love.sound.newSoundData("sfx/"..filename))
				else
					table.insert(s.sources,love.audio.newSource("sfx/"..filename,"static"))
					table.insert(s.pitchoffs,0)
				end
			end
		end
	end
	if positional then
		love.audio.setDistanceModel("exponent")
		love.audio.setOrientation(0,0,-1,0,1,0)
	end
	return s
end

sfx.play = function(index,x,y)
	local g=Game
	if not SFX.positional then
		local source=SFX.sources[index]
		if source then
			love.audio.stop(source)
			local pitch=math.clamp(g.speed,0.2,1)
			SFX.pitchoffs[index]=math.randomfraction(0.2)-0.1
			source:setPitch(pitch+SFX.pitchoffs[index])
			love.audio.play(source)
		end
	else
		local source=SFX.sources[index]
		if source then
			source=love.audio.newSource(source,"static")
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
		for i,v in pairs(s.sources) do
			local pitch=math.clamp(gs,0.2,1)
			v:setPitch(pitch+s.pitchoffs[i])
		end
	end
end

return sfx