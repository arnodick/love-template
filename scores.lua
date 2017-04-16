local function load()
	if not love.filesystem.exists("scores.ini") then
		local h={}
		local n={}
		for i=1,8 do
			table.insert(h,0)
			table.insert(n,"ABC")
		end
		local scores=
		{
			high=h,
			names=n
		}
		
		LIP.save("scores.ini",scores)
	end
	return LIP.load("scores.ini")
end

local function save()
	local scores=scores.load()
	local s={}
	for j=1,#scores.high do
		table.insert(s,{scores.names[j],scores.high[j]})
	end
	local score=Game.score
	table.insert(s,{"ASH",score})

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
	LIP.save("scores.ini",scores)
end

local function draw(x,y,c1,c2)
	local s=Game.scores

--TODO make this into menu library
	LG.setColor(Game.palette[EC.dark_purple])
	LG.rectangle("fill",x-20+1,y+1,52,102)
	LG.setColor(Game.palette[EC.black])
	LG.rectangle("fill",x-20,y,50,100)
	LG.setColor(Game.palette[EC.indigo])
	LG.rectangle("line",x-20,y,51,101)

	for i=1,#s.high do
		--LG.print(s.names[i],x-10,y+10*i)
		--LG.print(s.high[i],x+10,y+10*i)
		LG.printshadow(s.names[i],x-10,y+10*i,50,"left",c1,c2)
		LG.printshadow(s.high[i], x+10,y+10*i,50,"left",c1,c2)
	end
end

return
{
	load = load,
	save = save,
	draw = draw,
}