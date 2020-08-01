local music={}

music.play = function(index)
	local source=Music[index]
	if source~=nil then
		love.audio.play(source)
	end
end

music.stop = function(index)
	love.audio.stop(Music[index])
end

return music