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