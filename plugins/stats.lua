function q2a_load()
    gi.dprintf("hello.lua: q2a_load()\n")
end

function q2a_unload()
    gi.dprintf("hello.lua: q2a_unload()\n")
end

function ClientConnect(client, userinfo)
    local plr = ex.players[client]
    gi.dprintf("hello.lua: %s@%s is connecting\n", plr.name, plr.ip)
    return true
end

function ClientBegin(client)
    local plr = ex.players[client]
    gi.dprintf("hello.lua: %s@%s joined the game\n", plr.name, plr.ip)
end

function ClientDisconnect(client)
    local plr = ex.players[client]
    gi.dprintf("hello.lua: %s@%s disconnected\n", plr.name, plr.ip)
end

function ClientUserinfoChanged(client, userinfo)
    gi.dprintf("hello.lua: ClientUserinfoChanged(%d)\n", client)
end

function LevelChanged(level)
    gi.dprintf("hello.lua: LevelChanged(%s)\n", level)
end

function RunFrame()
    --gi.dprintf("hello.lua: RunFrame()\n")
end

function ClientThink(client)
    --gi.dprintf("hello.lua: ClientThink()\n")
end


local m4 = { "(.+) had a makeover by (.+)\'s M4 Assault Rifle"
           , "(.+) feels some heart burn thanks to (.+)\'s M4 Assault Rifle"
		   , "(.+) has an upset stomach thanks to (.+)\'s M4 Assault Rifle"
		   , "(.+) is now shorter thanks to (.+)\'s M4 Assault Rifle"
		   , "(.+) was shot by (.+)\'s M4 Assault Rifle"
		   , "(.+) plummets to his death" }


function LogMessage(msg)
    --debug of all incoming msg:
    --gi.AddCommandString("say "..msg.."\n")
	i = 1
	
	-- for evry array in m4 
	for k,v in pairs(m4) do
		
		--if string match in array m4
		if string.match(msg, m4[i]) then
			gi.bprintf(PRINT_CHAT, "[STATS]: "..m4[i].." \n")
		end

		i = i + 1
	end
	
 
end -- of LogMessage