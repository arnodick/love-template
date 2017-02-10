local function load(positional)
	local SFX = {}
	local files = love.filesystem.getDirectoryItems("sfx") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("sfx/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local ext = filedata:getExtension()
			local varname = string.gsub(filename, "."..ext, "")
			if ext == "ogg" or ext == "wav" then --if it's a .ogg, add to SFX (maybe make this flexible for other sound files ie mp3)
				SFX[varname] = love.audio.newSource("sfx/"..filename,"static")
				--SFX[varname] = filename
			end
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
	local source = SFX[tostring(index)]
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
		source:setPitch(Game.speed+math.randomfraction(0.2)-0.1)
		love.audio.play(source)
	end
end

return
{
	load = load,
	play = play,
}