-- NOTE - you need to install lua-http and lunajson via luarocks to run this plugin
-- luarocks install http
-- luarocks install lunajson
--
-- config example:
-- plugins = {
--    auth = {
--        url = 'https://fortnite.fi/api/v1'
--    }
-- }

mysql = require "luasql.mysql"

local env  = mysql.mysql()
local conn = env:connect('stats','stats','xxxxxx')


local http_request = require("http.request")
local lunajson = require("lunajson")

local base_url

function request(url, method, body)
    local req = http_request.new_from_uri(url)
    req.headers:upsert(':method', method)
    req.headers:upsert('Content-Type', 'application/json')
    req:set_body(body)
    local headers, stream = req:go()
    local body, err = stream:get_body_as_string()
    local parsedBody = lunajson.decode(body)
    return parsedBody
end

function q2a_load(config)
    base_url = config.url
    gi.dprintf("auth.lua: q2a_load()\n")
end

function q2a_unload()
    gi.dprintf("auth.lua: q2a_unload()\n")
end

function ClientConnect(client, userinfo)
  	local plr = ex.players[client] 
	local row
	cursor,errorString = conn:execute([[select * from players]])
	row = cursor:fetch ({}, "a")
	
	--remove special chars from string
	plr.name = plr.name:gsub( "\'", "" )
	
	while row do
	   -- reusing the table of results
		if plr.name == row.p_name then
			return true
		end
		
		row = cursor:fetch (row, "a")
	end

	gi.dprintf("auth.lua: %s@%s is connecting\n", plr.name, plr.ip)
    --put data in database
	status,errorString = conn:execute([[INSERT INTO players (p_name,p_ip) values(']]..plr.name..[[',']]..plr.ip..[[')]])
	print(status,errorString )
    return true
end

function ClientBegin(client, userinfo)
    gi.cprintf(client, PRINT_HIGH, "!auth_login_trigger\n")
    return true
end

function PrintUser(client)
    local user = ex.players[client]
    if user then
        for key, value in pairs(user) do
            gi.cprintf(client, PRINT_HIGH, key .. ": ")
            gi.cprintf(client, PRINT_HIGH, value .. "\n")
        end
        return true
    end
    gi.cprintf(client, PRINT_HIGH, "Client not found. Please reconnect.\n")
    return true
end

function Login (client)
    if gi.argc() > 1 then
        local body = '{"quake_id":"' .. gi.argv(2) .. '"}'
        local user = request(base_url .. "/login", "POST", body)
        if ex.players[client] then
            ex.players[client].quake_id = user.quake_id
            gi.centerprintf(client, "Logged in")
            return true
        end
        gi.cprintf(client, PRINT_HIGH, "Client not found. Please reconnect.\n")
    else
        gi.cprintf(client, PRINT_HIGH, "Auth: usage: login <quake id>\n")
    end
    return true
end

function ClientCommand(client)
    local cmd = gi.argv(1)

    if cmd == "!login" then return Login(client) end     
    if cmd == "!me" then return PrintUser(client) end

    return false
end

function LogMessage(msg)
	
	--print(msg,"[discord_id][p_name][p_ip][p_victem][p_weapon][p_weapon_loc]-(.+)-(.+)-(.+)-(.+)-(.+)-(.+)-")
	--print(msg)
	if string.match(msg,"[075STATS]-(.+)-(.+)-(.+)-(.+)-(.+)-(.+)-(.+)-(.+)-") then
		local stats = {}
		--gi.bprintf(PRINT_CHAT, "[DEBUG_MSG]  \n")
		for item in string.gmatch(msg, "([^-]+)") do
			--print(item)
			table.insert(stats, item)
		end
		
		p_niks1			= (stats[1])
		attackerid		= (stats[2])
		p_name 			= (stats[3])
		p_ip			= (stats[4])
		victemid		= (stats[5])
		p_victem		= (stats[6])
		p_weapon		= (stats[7])
		p_weapon_loc	= (stats[8])
		
		--print to check
		print("[------------[STATS---------------]")
		print("[-- p_nikss    = "..p_niks1.."")
		print("[-- attackerID = "..attackerid.."")
		print("[-- Name       = "..p_name.."")
		print("[-- Ip         = "..p_ip.."")
		print("[-- VictemID   = "..victemid.."")
		print("[-- Victem     = "..p_victem.."")
		print("[-- Weapon     = "..p_weapon.."")
		print("[-- Location   = "..p_weapon_loc.."")
		print("[------------[STATS---------------]")
		
		--remove special chars from string
		p_name = p_name:gsub( "\'", "" )
		
		-- Update player stats
		status,errorString = conn:execute([[UPDATE players SET ]]..p_weapon.. [[ = ]]..p_weapon..[[+1 WHERE p_name = ']]..p_name..[[']])
		print(status,errorString )
	end
 
end -- of LogMessage