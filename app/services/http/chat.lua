local cjson = require("cjson.safe")
local server = require "resty.websocket.server"
local redis = require "resty.redis"

local _M = {_VERSION = "0.1.0"}

function _M.new(self)
    return setmetatable({}, {__index = _M})
end

local uri = ngx.var.uri
local len = string.len("/s/")
local channel_id = string.sub(uri, len + 1, -1)

local channel_name = "chat_" .. tostring(channel_id)

print("channel_id: ", channel_id, "channel_name: ", channel_name)

--create connection
local wb, err = server:new {
    timeout = 10000,
    max_payload_len = 65535
}

if not wb then
    ngx.log(ngx.ERR, "failed to new websocket: ", err)
    return ngx.exit(444)
end

local function push(...)
    --create redis
    local red = redis:new()
    red:set_timeout(5000) -- 1 sec
    local ok, err = red:connect("127.0.0.1", 6379)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect redis: ", err)
        wb:send_close()
        return
    end

    --sub
    local res, err = red:subscribe(channel_name)
    if not res then
        ngx.log(ngx.ERR, "failed to sub redis: ", err)
        wb:send_close()
        return
    end

    -- loop : read from redis
    while true do
        local res, err = red:read_reply()
        if res then
            local item = res[3]
            local bytes, err = wb:send_text("respone to " .. tostring(channel_id) .. ": " .. item)
            if not bytes then
                -- better error handling
                ngx.log(ngx.ERR, "failed to send text: ", err)
                return ngx.exit(444) -- not respone
            end
        end
    end

    local ok, err = red:set_keepalive(6000, 300)
    if not ok then
        log(ERR, "redis set_keepalive error =>  ", err)
        return
    end
end

function _M.run(param)
    local co = ngx.thread.spawn(push)

    --main loop
    while true do
        local data, type, err = wb:recv_frame()

        if wb.fatal then
            ngx.log(ngx.ERR, "failed to receive frame: ", err)
            return ngx.exit(444)
        end

        if not data then
            local bytes, err = wb:send_ping()
            if not bytes then
                ngx.log(ngx.ERR, "failed to send ping: ", err)
                return ngx.exit(444)
            end
            print("send ping: ", data)

        elseif type == "close" then
            break

        elseif type == "ping" then
            local bytes, err = wb:send_pong()
            if not bytes then
                ngx.log(ngx.ERR, "failed to send pong: ", err)
                return ngx.exit(444)
            end

        elseif type == "pong" then
            print("client ponged")

        elseif type == "text" then
            --send to redis
            local red = redis:new()
            red:set_timeout(1000) -- 1 sec
            local ok, err = red:connect("127.0.0.1", 6379)
            if not ok then
                ngx.log(ngx.ERR, "failed to connect redis: ", err)
                break
            end
            local res, err = red:publish(channel_name, data)
            if not res then
                ngx.log(ngx.ERR, "failed to publish redis: ", err)
            end

            local ok, err = red:set_keepalive(6000, 300)
            if not ok then
                log(ERR, "redis set_keepalive error =>  ", err)
                return
            end
            print("data: ", data)
        end
    end

    wb:send_close()
    ngx.thread.wait(co)
end

return _M
