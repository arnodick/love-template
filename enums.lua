local function constants(e) --NOTE this function has side effects! makes global variables
	if e.modules then
		EM=e.modules
		if EM.menus then
			EMM=EM.menus
		end
		if EM.controllers then
			EMC=EM.controllers
			if EMC.inputs then
				EMCI=EMC.inputs
			end
		end

	end
	e.flags=flags.load()
	EF=e.flags
	LG=love.graphics
end

return
{
	constants = constants,
}