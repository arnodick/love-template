local sfx={}

sfx.load = function(positional)
	local s={}
	s.positional=positional or false
	local files=love.filesystem.getDirectoryItems("sfx") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("sfx/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local ext = filedata:getExtension()
			if ext=="ogg" or ext=="wav" then --if it's a .ogg, add to SFX (maybe make this flexible for other sound files ie mp3)
				local soundfx={}
				if positional then
					soundfx.source=love.sound.newSoundData("sfx/"..filename)
					table.insert(s,love.sound.newSoundData("sfx/"..filename))
				else
					soundfx.source=love.audio.newSource("sfx/"..filename,"static")
					soundfx.pitchoffs=0
					table.insert(s,soundfx)
					supper.print(soundfx)
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
		local source=SFX[index].source
		if source then
			love.audio.stop(source)
			local pitch=math.clamp(g.speed,0.2,1)
			SFX[index].pitchoffs=math.randomfraction(0.2)-0.1
			source:setPitch(pitch+SFX[index].pitchoffs)
			love.audio.play(source)
		end
	else
		local source=SFX[index].source
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
		for i,v in ipairs(s) do
			local pitch=math.clamp(gs,0.2,1)
			v.source:setPitch(pitch+s[i].pitchoffs)
		end
	end
end

return sfx