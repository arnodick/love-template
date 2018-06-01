local sfx={}

sfx.load = function(positional,pitchupdate)
	local s = {}
	s.sources={}
	s.pitchoffs={}
	local files = love.filesystem.getDirectoryItems("sfx") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("sfx/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local ext = filedata:getExtension()
			if ext == "ogg" or ext == "wav" then --if it's a .ogg, add to SFX (maybe make this flexible for other sound files ie mp3)
				if positional then
					table.insert(s.sources,love.sound.newSoundData("sfx/"..filename))
				else
					table.insert(s.sources,love.audio.newSource("sfx/"..filename,"static"))
				end
			end
			table.insert(s.pitchoffs,0)
		end
	end
	if positional then
		love.audio.setDistanceModel("exponent")
		love.audio.setOrientation(0,0,-1,0,1,0)
	end
	s.positional=positional
	s.pitchupdate=pitchupdate
	return s
end

sfx.play = function(index,x,y)
	if not SFX.positional then
		local interrupt = interrupt or true
		local i=index
		local source = SFX.sources[i]
		if source~=nil then
			if interrupt then
				love.audio.stop(source)
			end
			if x~=nil and y~=nil and SFX.positional then
				source:setRelative(false)
				source:setPosition(x,y,0)
				source:setRolloff(0.4)
			end
			local pitch=math.clamp(Game.speed,0.2,1)
			SFX.pitchoffs[i]=math.randomfraction(0.2)-0.1
			source:setPitch(pitch+SFX.pitchoffs[i])
			love.audio.play(source)
		end
	else
		local interrupt = interrupt or true
		local i=index
		local source = SFX.sources[i]
		if source~=nil then
			source=love.audio.newSource(source,"static")
			local play=false
			if not SFX.positional then
				play=true
			elseif x~=nil and y~=nil and SFX.positional then
				source:setRelative(false)
				source:setPosition(x,y,0)
				source:setRolloff(0.2)
				if vector.distance(x,y,Game.camera.x,Game.camera.y)<320 then
					play=true
				end
			end
			if play then
				local pitch=math.clamp(Game.speed,0.2,1)
				SFX.pitchoffs[i]=math.randomfraction(0.2)-0.1
				source:setPitch(pitch+SFX.pitchoffs[i])
				love.audio.play(source)
			end
		end
	end
end

sfx.update = function(s,gs)
	if not s.positional then
		if s.pitchupdate then
			for i,v in pairs(s.sources) do
				local pitch=math.clamp(gs,0.2,1)
				v:setPitch(pitch+s.pitchoffs[i])
			end
		end
	end
end

return sfx