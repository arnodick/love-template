local transition={}

transition.make = function(g,a,m,easing,variablename,startvalue,change,duration,complete,complete_args,t)
	m.starttime=g.timer
	m.easing=easing
	m.variablename=variablename
	m.startvalue=startvalue
	m.change=change
	m.duration=duration
	m.complete=complete
	m.complete_args=complete_args
	m.t=t
	if m.t then
		print("m.t "..m.t)
		print("EM.transitions[m.t] "..EM.transitions[m.t])
		run(EM.transitions[m.t],"make",g,a,m)
	end
	a[m.variablename]=startvalue
	--print(startvalue)
	--print(startvalue+change)
end

transition.control = function(g,a,m)
	local timeelapsed=g.timer-m.starttime
	a[m.variablename]=m.easing(timeelapsed,m.startvalue,m.change,m.duration)

	-- print(m.variablename.." "..a[m.variablename].." at: "..timeelapsed)

	-- print(a[m.variablename])

	if m.t then
		run(EM.transitions[m.t],"control",a,m)
	end

	if timeelapsed>=m.duration then
		if m.complete then
			print("TRANSITION COMPLETE "..tostring(m.complete_args))
			if m.t==EM.transitions.destroy then
				print("TRANSITION DESTROY")
				m.complete(m.complete_args)
			elseif type(m.complete_args)=="table" then
					m.complete(unpack(m.complete_args))
			else
				m.complete(m.complete_args)
			end
		end
		a[m.variablename]=m.startvalue+m.change
		a.transition=nil
	end
end

return transition