local function load(positional)
	local SFX = {}
	SFX.sources={}
	SFX.pitchoffs={}
	local files = love.filesystem.getDirectoryItems("sfx") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("sfx/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local ext = filedata:getExtension()
			local varname = string.gsub(filename, "."..ext, "")
			if ext == "ogg" or ext == "wav" then --if it's a .ogg, add to SFX (maybe make this flexible for other sound files ie mp3)
				table.insert(SFX.sources,love.audio.newSource("sfx/"..filename,"static"))
				--SFX.sources[varname] = love.audio.newSource("sfx/"..filename,"static")
				--SFX[varname] = filename
			end
			table.insert(SFX.pitchoffs,0)
		end
	end
	if positional then
		love.audio.setDistanceModel("exponent")
		love.audio.setOrientation(0,0,-1,0,1,0)
	end
	SFX.positional=positional
	return SFX
end

local function play(index,x,y)
	interrupt = interrupt or true
	--local i=tostring(index)
	local i=index
	local source = SFX.sources[i]
	--local source = love.audio.newSource("sfx/"..SFX[tostring(index)],"static")
	if source~=nil then
		if interrupt then
			love.audio.stop(source)
		end
		if x~=nil and y~=nil and SFX.positional then
			source:setRelative(false)
			source:setPosition(x,y,0)
			source:setRolloff(0.05)
		end
		local pitch=math.clamp(Game.speed,0.2,1)
		SFX.pitchoffs[i]=math.randomfraction(0.2)-0.1
		source:setPitch(pitch+SFX.pitchoffs[i])
		--source:setPitch(pitch)
		love.audio.play(source)
	end
end

return
{
	load = load,
	play = play,
}