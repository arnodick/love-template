local function init(e) --NOTE this function has side effects! makes global variables
	if e.actors then
		EA=e.actors
	end
	if e.colours then
		EC=e.colours
	end
	LG=love.graphics
end

return
{
	init = init,
}