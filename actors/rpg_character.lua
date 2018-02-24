local function make(g,a,c,size,char,hp)
	local e=Enums

	a.cinit=c or EC.dark_blue
	a.c=a.cinit or EC.blue
	a.size=size or 1
	a.char=char or "X"
	a.hp=hp or 8

	a.flags=flags.set(a.flags,EF.character,EF.damageable,EF.shootable,EF.explosive)
end

return
{
	make = make,
}