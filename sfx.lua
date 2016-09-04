local function load()
	local SFX = {}
	local files = love.filesystem.getDirectoryItems("sfx") --get all the files+directories in sfx dir
	for i = 1,#files do
		if love.filesystem.isFile("sfx/"..files[i]) then --if it isn't a directory
			local filedata = love.filesystem.newFileData("sound", files[i])
			local filename = filedata:getFilename() --get the sound file's name
			local varname = string.gsub(filename, ".wav", "")
			if filedata:getExtension() == "wav" then --if it's a .wav, add to SFX (maybe make this flexible for other sound files ie mp3)
				SFX[varname] = love.audio.newSource("sfx/"..filename)
			end
		end
	end
	return SFX
end

return
{
	load = load,
}