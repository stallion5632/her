
local cjson = require("cjson.safe")
local _M = {}

local CLIENTS = setmetatable({}, { __mode = 'k' })

local user_dao = require("lua.persistence.dao.user_dao")
local user = user_dao:new()


local function bytes_to_int(str,endian,signed) -- use length of string to determine 8,16,32,64 bits
	local t={str:byte(1,-1)}
	if endian=="big" then --reverse bytes
		local tt={}
		for k=1,#t do
			tt[#t-k+1]=t[k]
		end
		t=tt
	end
	local n=0
	for k=1,#t do
		n=n+t[k]*2^((k-1)*8)
	end
	if signed then
		n = (n > 2^(#t-1) -1) and (n - 2^#t) or n -- if last bit set, negative.
	end
	return n
end


function _M.go()
    local ctx = ngx.ctx

    local sock, err = ngx.req.socket()
    if not sock then
        ngx.log(ngx.ERR, "unable to obtain request socket: ", err)

        return
    end

    CLIENTS[ctx] = true


    ngx.thread.spawn(function()
        while true do
			message, err = sock:receive(4)
			if not message or err then
				ngx.log(ngx.ERR, err)
				
			end
			ngx.log(ngx.ERR, message)
			local  len = bytes_to_int(message)

			message, err = sock:receive(4)
			if not message or err then
				ngx.log(ngx.ERR, err)
			end
			local  code = bytes_to_int(message)

			message, err = sock:receive(len - 4)
			local t = cjson.decode(message)
			if not t then
				ngx.log(ngx.ERR, err)
            end
			
			local b, err = user:insert_user({t})
			if not b or err then
				ngx.log(ngx.ERR, err)
			end

			
            if message == '\\quit' then
                return ngx.exit(200)
            end

            _, err = sock:send(message .. '\n' )
            if err then
                ngx.log(ngx.ERR, "unable to read request socket: ", err)

                return ngx.exit(500)
			end
			break;
        end
    end)
end


return _M
