local scores={}

--TODO take g in, has settings for amount of scores etc
--TODO score.make? makes a {"name",score} table
--TODO score.sort, orders scores by value, descending ascending option
scores.load = function()
	if not love.filesystem.exists("scores.json") then
		local s={}
		for i=1,8 do
			table.insert(s,{name="ASH",score=love.math.random(10)})
		end
		scores.sort(s)
		json.save("scores.json",s)
	end
	-- return json.load("scores.json")
	return s
end

scores.sort = function(s,descending)
	descending=descending or false
	local function scoresort(a,b)
		if a.score<b.score then
			return descending
		else
			return not descending
		end
	end
	table.sort(s,scoresort)
end

scores.update = function()
	local scores=scores.load()
	local s={}
	for j=1,#scores.high do
		table.insert(s,{scores.names[j],scores.high[j]})
	end
	local score=Game.score
	table.insert(s,{"",score})

	local function scoresort(a,b)
		if a[2]>b[2] then
			return true
		else
			return false
		end
	end

	table.sort(s,scoresort)

	for i=#s,1,-1 do
		if i>8 then
			table.remove(s,i)
		end
	end

	scores.high={}
	scores.names={}
	for k=1,#s do
		scores.names[k]=s[k][1]
		scores.high[k]=s[k][2]
	end

	Game.scores=scores
end

scores.save = function()
	for i=1,#Game.scores.names do
		if Game.scores.names[i]=="" then
			Game.scores.names[i]="X"
		end
	end
	LIP.save("scores.ini",Game.scores)
end

return scores