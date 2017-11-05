local nanogenmo={}

local sentence={}

sentence.declarative = function(words)
	return "The "..words[love.math.random(#words)].." is not like the "..words[love.math.random(#words)].."."
end

sentence.exclamatory = function(words)
	return "Exclamatory!"
end

nanogenmo.make = function(g,tw,th,gw,gh,sp)
	local n={}
	for k,v in pairs(sentence) do
		table.insert(n,k)
	end
	sentence.names=n
end

nanogenmo.intro =
{
	make = function(g)
		--g.sentence=sentence.declarative({"jeep","moss","person","bulk","rest","boar","crisis"})
		local t=sentence.names[love.math.random(#sentence.names)]
		--g.sentence=run(sentence,t,{"jeep","moss","person","bulk","rest","boar","crisis"})
		g.sentence=supper.run(sentence,{t},{"jeep","moss","person","bulk","rest","boar","crisis"})
		print(g.sentence)
	end,

	keypressed = function(g,key)
		if key=='escape' then
			love.event.quit()
		elseif key=="return" then
			--g.sentence=g.sentence.."\n"..sentence.declarative({"jeep","moss","person","bulk","rest","boar","crisis"})
			local t=sentence.names[love.math.random(#sentence.names)]
			g.sentence=g.sentence.."\n"..supper.run(sentence,{t},{"jeep","moss","person","bulk","rest","boar","crisis"})
		elseif key=="space" then
			love.filesystem.write("nano.txt",g.sentence)
		end
	end,

	draw = function(g)
		LG.print(g.name.." GAEM_PLAY",g.width/2,g.height/2)
		LG.print(g.sentence,0,g.height/2 + 20)
	end
}

return nanogenmo