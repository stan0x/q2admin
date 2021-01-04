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


function LogMessage(msg)
	
	
	if string.match(msg,"[p_name][p_ip][p_victem][p_weapon][p_weapon_loc]-(.+)-(.+)-(.+)-(.+)-(.+)-") then
		local stats = {}
		--gi.bprintf(PRINT_CHAT, "[DEBUG_MSG]  \n")
		for item in string.gmatch(msg, "([^-]+)") do
			--print(item)
			table.insert(stats, item)
		end
		
		p_niks1			= (stats[0])
		p_niks2			= (stats[1])
		p_name 			= (stats[2])
		p_ip			= (stats[3])
		p_victem		= (stats[4])
		p_weapon		= (stats[5])
		p_weapon_loc	= (stats[6])
		
		print("[------------[STATS---------------]")
		print("[-- Name      = "..p_name.."")
		print("[-- Ip        = "..p_ip.."")
		print("[-- Victem    = "..p_victem.."")
		print("[-- Weapon    = "..p_weapon.."")
		print("[-- Location  = "..p_weapon_loc.."")
		print("[------------[STATS---------------]")
		
	end
 
end -- of LogMessage


gi.dprintf("hello.lua: plugin loaded\n")